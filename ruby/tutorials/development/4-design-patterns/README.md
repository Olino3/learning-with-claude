# Tutorial 4: Design Patterns - Service Objects & More

Master the essential Ruby design patterns that keep your application organized, testable, and maintainable. This tutorial covers Service Objects, Decorators, Query Objects, Form Objects, and Policy Objects—the building blocks of clean Ruby architecture.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Build Service Objects for complex business logic
- Use Decorators and Presenters for view logic
- Create Query Objects for complex database queries
- Implement Form Objects for multi-model forms
- Write Policy Objects for authorization
- Understand when to use each pattern
- Compare Ruby patterns to Python equivalents
- Keep your models and controllers thin

## 🐍➡️🔴 Coming from Python

If you're familiar with Python design patterns, here's how Ruby patterns compare:

| Pattern | Python | Ruby | Use Case |
|---------|--------|------|----------|
| Service Object | Service class | Service Object | Business logic |
| Decorator | `@decorator` | Decorator/Draper | Adding behavior |
| Presenter | Django template tags | Presenter | View logic |
| Query Object | Django QuerySet | Query Object | Complex queries |
| Form Object | Django Form | Form Object | Form handling |
| Policy Object | Django permissions | Pundit/Policy | Authorization |
| Factory | `__init__` + classmethod | Factory | Object creation |
| Repository | Django ORM Manager | Repository | Data access |

> **📘 Python Note:** Ruby patterns are similar to Python but more formalized. Django developers will recognize many concepts from Django's class-based views and forms.

## 📝 Part 1: Service Objects

Service Objects encapsulate complex business operations into single-purpose classes.

### The Problem: Fat Controllers

```ruby
# Bad: Business logic in controller
class OrdersController < ApplicationController
  def create
    @order = Order.new(order_params)
    @order.user = current_user

    if @order.valid?
      ActiveRecord::Base.transaction do
        @order.calculate_tax
        @order.calculate_shipping
        @order.apply_discounts

        if @order.save
          # Charge payment
          result = Stripe::Charge.create(
            amount: @order.total_cents,
            currency: 'usd',
            customer: current_user.stripe_customer_id
          )

          @order.update(payment_id: result.id)

          # Send emails
          OrderMailer.confirmation(@order).deliver_later
          OrderMailer.admin_notification(@order).deliver_later

          # Update inventory
          @order.items.each do |item|
            item.product.decrement!(:stock, item.quantity)
          end

          redirect_to @order, notice: 'Order created!'
        else
          render :new
        end
      end
    else
      render :new
    end
  rescue Stripe::CardError => e
    flash[:error] = "Payment failed: #{e.message}"
    render :new
  end
end
```

### The Solution: Service Object

```ruby
# app/services/orders/create_service.rb
module Orders
  class CreateService
    def initialize(params:, user:)
      @params = params
      @user = user
    end

    def call
      @order = build_order

      return failure_result unless @order.valid?

      ActiveRecord::Base.transaction do
        prepare_order
        process_payment
        finalize_order
      end

      success_result
    rescue Stripe::CardError => e
      failure_result(error: "Payment failed: #{e.message}")
    end

    private

    attr_reader :params, :user, :order

    def build_order
      Order.new(params).tap do |order|
        order.user = user
      end
    end

    def prepare_order
      order.calculate_tax
      order.calculate_shipping
      order.apply_discounts
      order.save!
    end

    def process_payment
      result = Stripe::Charge.create(
        amount: order.total_cents,
        currency: 'usd',
        customer: user.stripe_customer_id
      )

      order.update!(payment_id: result.id)
    end

    def finalize_order
      send_notifications
      update_inventory
    end

    def send_notifications
      OrderMailer.confirmation(order).deliver_later
      OrderMailer.admin_notification(order).deliver_later
    end

    def update_inventory
      order.items.each do |item|
        item.product.decrement!(:stock, item.quantity)
      end
    end

    def success_result
      OpenStruct.new(success?: true, order: order)
    end

    def failure_result(error: nil)
      OpenStruct.new(
        success?: false,
        order: order,
        error: error || order.errors.full_messages.join(', ')
      )
    end
  end
end

# Controller becomes thin
class OrdersController < ApplicationController
  def create
    result = Orders::CreateService.new(
      params: order_params,
      user: current_user
    ).call

    if result.success?
      redirect_to result.order, notice: 'Order created!'
    else
      @order = result.order
      flash.now[:error] = result.error
      render :new
    end
  end
end
```

> **📘 Python Note:** This is similar to Django service classes:
> ```python
> class CreateOrderService:
>     def __init__(self, order_data, user):
>         self.order_data = order_data
>         self.user = user
>
>     def execute(self):
>         # Business logic here
> ```

### Service Object Pattern

```ruby
# Generic service object structure
module ServiceName
  class OperationService
    def initialize(**dependencies)
      @dependencies = dependencies
    end

    def call
      # Main business logic
      # Return result object
    end

    private

    # Helper methods
  end
end

# Usage
result = ServiceName::OperationService.new(params).call
if result.success?
  # Handle success
else
  # Handle failure
end
```

### Result Objects

```ruby
# app/services/result.rb
class ServiceResult
  attr_reader :value, :error

  def initialize(success:, value: nil, error: nil)
    @success = success
    @value = value
    @error = error
  end

  def success?
    @success
  end

  def failure?
    !@success
  end
end

# Usage in services
def call
  # Success
  ServiceResult.new(success: true, value: order)

  # Failure
  ServiceResult.new(success: false, error: 'Invalid order')
end
```

### Testing Service Objects

```ruby
# spec/services/orders/create_service_spec.rb
RSpec.describe Orders::CreateService do
  describe '#call' do
    let(:user) { create(:user) }
    let(:params) { attributes_for(:order) }

    subject(:service) { described_class.new(params: params, user: user) }

    context 'with valid params' do
      it 'creates an order' do
        expect { service.call }.to change { Order.count }.by(1)
      end

      it 'charges payment' do
        expect(Stripe::Charge).to receive(:create)
        service.call
      end

      it 'sends confirmation email' do
        expect(OrderMailer).to receive(:confirmation)
          .and_return(double(deliver_later: true))
        service.call
      end

      it 'returns success result' do
        result = service.call
        expect(result).to be_success
        expect(result.order).to be_persisted
      end
    end

    context 'with invalid params' do
      let(:params) { { total: -100 } }

      it 'does not create order' do
        expect { service.call }.not_to change { Order.count }
      end

      it 'returns failure result' do
        result = service.call
        expect(result).to be_failure
        expect(result.error).to be_present
      end
    end

    context 'when payment fails' do
      before do
        allow(Stripe::Charge).to receive(:create)
          .and_raise(Stripe::CardError.new('Card declined', nil))
      end

      it 'rolls back transaction' do
        expect { service.call }.not_to change { Order.count }
      end

      it 'returns payment error' do
        result = service.call
        expect(result).to be_failure
        expect(result.error).to include('Payment failed')
      end
    end
  end
end
```

## 📝 Part 2: Decorators and Presenters

Decorators add presentation logic without polluting models.

### The Problem: View Logic in Models

```ruby
# Bad: Presentation logic in model
class User < ApplicationRecord
  def display_name
    "#{first_name} #{last_name}"
  end

  def avatar_url
    avatar.present? ? avatar.url : '/default-avatar.png'
  end

  def joined_date
    created_at.strftime('%B %d, %Y')
  end

  def status_badge
    if admin?
      '<span class="badge badge-danger">Admin</span>'.html_safe
    else
      '<span class="badge badge-primary">User</span>'.html_safe
    end
  end
end
```

### The Solution: Decorator Pattern

```ruby
# app/decorators/user_decorator.rb
class UserDecorator < SimpleDelegator
  def display_name
    "#{first_name} #{last_name}"
  end

  def avatar_url
    __getobj__.avatar.present? ? avatar.url : '/default-avatar.png'
  end

  def joined_date
    created_at.strftime('%B %d, %Y')
  end

  def status_badge
    h.content_tag :span, role_text, class: "badge badge-#{badge_color}"
  end

  private

  def role_text
    admin? ? 'Admin' : 'User'
  end

  def badge_color
    admin? ? 'danger' : 'primary'
  end

  def h
    ApplicationController.helpers
  end
end

# Controller
def show
  @user = UserDecorator.new(User.find(params[:id]))
end

# View
<%= @user.display_name %>
<%= @user.status_badge %>
```

### Using Draper Gem

```ruby
# Gemfile
gem 'draper'

# app/decorators/user_decorator.rb
class UserDecorator < Draper::Decorator
  delegate_all

  def display_name
    "#{object.first_name} #{object.last_name}"
  end

  def avatar_url
    object.avatar.present? ? object.avatar.url : h.image_path('default-avatar.png')
  end

  def joined_date
    h.content_tag :time, object.created_at.strftime('%B %d, %Y'),
                  datetime: object.created_at.iso8601
  end

  def status_badge
    h.content_tag :span, role_text, class: "badge badge-#{badge_color}"
  end

  def profile_link
    h.link_to display_name, h.user_path(object), class: 'user-link'
  end

  private

  def role_text
    object.admin? ? 'Admin' : 'User'
  end

  def badge_color
    object.admin? ? 'danger' : 'primary'
  end
end

# Controller
def index
  @users = User.all.decorate
end

def show
  @user = User.find(params[:id]).decorate
end
```

> **📘 Python Note:** This is similar to Django template filters and tags, but more object-oriented:
> ```python
> # Python/Django approach
> @register.filter
> def display_name(user):
>     return f"{user.first_name} {user.last_name}"
> ```

## 📝 Part 3: Query Objects

Query Objects encapsulate complex database queries.

### The Problem: Complex Scopes

```ruby
# Bad: Complex query in controller
class ProductsController < ApplicationController
  def index
    @products = Product.joins(:category)
                       .where(categories: { active: true })
                       .where('price >= ?', params[:min_price])
                       .where('price <= ?', params[:max_price])
                       .where('stock > ?', 0)
                       .order(created_at: :desc)
                       .page(params[:page])
  end
end
```

### The Solution: Query Object

```ruby
# app/queries/products/search_query.rb
module Products
  class SearchQuery
    def initialize(relation = Product.all)
      @relation = relation
    end

    def call(filters = {})
      @relation
        .then { |r| by_category(r, filters[:category_id]) }
        .then { |r| by_price_range(r, filters[:min_price], filters[:max_price]) }
        .then { |r| in_stock(r) }
        .then { |r| search(r, filters[:query]) }
        .then { |r| sort(r, filters[:sort]) }
    end

    private

    def by_category(relation, category_id)
      return relation unless category_id.present?

      relation.joins(:category).where(categories: { id: category_id, active: true })
    end

    def by_price_range(relation, min_price, max_price)
      relation = relation.where('price >= ?', min_price) if min_price.present?
      relation = relation.where('price <= ?', max_price) if max_price.present?
      relation
    end

    def in_stock(relation)
      relation.where('stock > ?', 0)
    end

    def search(relation, query)
      return relation unless query.present?

      relation.where('name ILIKE ? OR description ILIKE ?', "%#{query}%", "%#{query}%")
    end

    def sort(relation, sort_option)
      case sort_option
      when 'price_asc' then relation.order(price: :asc)
      when 'price_desc' then relation.order(price: :desc)
      when 'name' then relation.order(name: :asc)
      else relation.order(created_at: :desc)
      end
    end
  end
end

# Controller
class ProductsController < ApplicationController
  def index
    @products = Products::SearchQuery.new.call(search_params).page(params[:page])
  end

  private

  def search_params
    params.permit(:category_id, :min_price, :max_price, :query, :sort)
  end
end
```

> **📘 Python Note:** Similar to Django's custom QuerySet managers:
> ```python
> class ProductQuerySet(models.QuerySet):
>     def in_stock(self):
>         return self.filter(stock__gt=0)
>
>     def by_price_range(self, min_price, max_price):
>         return self.filter(price__range=(min_price, max_price))
> ```

## 📝 Part 4: Form Objects

Form Objects handle complex forms that span multiple models.

### The Problem: Multi-Model Forms

```ruby
# Bad: Complex form handling in controller
class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    @profile = Profile.new(profile_params)
    @address = Address.new(address_params)

    if @user.valid? && @profile.valid? && @address.valid?
      ActiveRecord::Base.transaction do
        @user.save!
        @profile.user = @user
        @profile.save!
        @address.user = @user
        @address.save!
      end
      redirect_to @user
    else
      render :new
    end
  end
end
```

### The Solution: Form Object

```ruby
# app/forms/user_registration_form.rb
class UserRegistrationForm
  include ActiveModel::Model

  attr_accessor :email, :password, :password_confirmation
  attr_accessor :first_name, :last_name, :bio
  attr_accessor :street, :city, :state, :zip_code

  validates :email, :password, :first_name, :last_name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }
  validates :password, confirmation: true
  validates :street, :city, :state, :zip_code, presence: true

  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      create_user
      create_profile
      create_address
    end

    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def user
    @user ||= User.new
  end

  private

  def create_user
    @user = User.create!(
      email: email,
      password: password,
      password_confirmation: password_confirmation
    )
  end

  def create_profile
    Profile.create!(
      user: @user,
      first_name: first_name,
      last_name: last_name,
      bio: bio
    )
  end

  def create_address
    Address.create!(
      user: @user,
      street: street,
      city: city,
      state: state,
      zip_code: zip_code
    )
  end
end

# Controller
class UsersController < ApplicationController
  def create
    @form = UserRegistrationForm.new(registration_params)

    if @form.save
      redirect_to @form.user, notice: 'Welcome!'
    else
      render :new
    end
  end

  private

  def registration_params
    params.require(:user_registration_form).permit(
      :email, :password, :password_confirmation,
      :first_name, :last_name, :bio,
      :street, :city, :state, :zip_code
    )
  end
end

# View
<%= form_with model: @form, url: users_path do |f| %>
  <%= f.text_field :email %>
  <%= f.password_field :password %>
  <%= f.text_field :first_name %>
  <%= f.text_area :bio %>
  <%= f.text_field :street %>
  <%= f.submit %>
<% end %>
```

> **📘 Python Note:** Very similar to Django Forms:
> ```python
> class UserRegistrationForm(forms.Form):
>     email = forms.EmailField()
>     password = forms.CharField(widget=forms.PasswordInput)
>
>     def save(self):
>         # Create user and related objects
> ```

## 📝 Part 5: Policy Objects

Policy Objects encapsulate authorization logic.

### Using Pundit

```ruby
# Gemfile
gem 'pundit'

# app/policies/post_policy.rb
class PostPolicy
  attr_reader :user, :post

  def initialize(user, post)
    @user = user
    @post = post
  end

  def index?
    true
  end

  def show?
    post.published? || owner? || admin?
  end

  def create?
    user.present?
  end

  def update?
    owner? || admin?
  end

  def destroy?
    owner? || admin?
  end

  def publish?
    owner? || admin?
  end

  private

  def owner?
    user == post.user
  end

  def admin?
    user&.admin?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user&.admin?
        scope.all
      elsif user
        scope.where(published: true).or(scope.where(user: user))
      else
        scope.where(published: true)
      end
    end
  end
end

# Controller
class PostsController < ApplicationController
  def index
    @posts = policy_scope(Post)
  end

  def show
    @post = Post.find(params[:id])
    authorize @post
  end

  def update
    @post = Post.find(params[:id])
    authorize @post
    # Update logic
  end
end

# View
<% if policy(@post).update? %>
  <%= link_to 'Edit', edit_post_path(@post) %>
<% end %>

<% if policy(@post).destroy? %>
  <%= link_to 'Delete', @post, method: :delete %>
<% end %>
```

> **📘 Python Note:** Similar to Django permissions:
> ```python
> class PostPermission(permissions.BasePermission):
>     def has_object_permission(self, request, view, obj):
>         return obj.user == request.user or request.user.is_staff
> ```

## ✍️ Exercises

### Exercise 1: Service Objects
👉 **[Build Service Objects](exercises/1-service-objects.md)**

Create service objects for:
- User registration with email verification
- Payment processing with Stripe
- Report generation with background jobs
- Multi-step wizard workflows

### Exercise 2: Decorators and Query Objects
👉 **[Decorators & Queries](exercises/2-decorators-queries.md)**

Build:
- User decorator with social media links
- Product decorator with pricing display
- Complex product search query
- Analytics query object

### Exercise 3: Forms and Policies
👉 **[Forms & Authorization](exercises/3-forms-policies.md)**

Implement:
- Multi-model checkout form
- Nested resource forms
- Pundit policies for blog
- Custom authorization rules

## 📚 What You Learned

✅ Service Objects for business logic
✅ Decorators for presentation logic
✅ Query Objects for complex queries
✅ Form Objects for multi-model forms
✅ Policy Objects for authorization
✅ When to use each pattern
✅ Testing strategies for patterns
✅ Keeping models and controllers thin

## 🔜 Next Steps

**Next: [Tutorial 5: SOLID Principles](../5-solid-principles/README.md)**

Learn to:
- Apply Single Responsibility Principle
- Follow Open/Closed Principle
- Implement dependency injection
- Write SOLID Ruby code

## 💡 Key Takeaways for Python Developers

1. **Service Objects ≈ Django Services**: Encapsulate business logic
2. **Decorators ≈ Template Tags**: Add presentation behavior
3. **Query Objects ≈ Custom QuerySets**: Complex query logic
4. **Form Objects ≈ Django Forms**: Multi-model form handling
5. **Policies ≈ Django Permissions**: Authorization rules
6. **Thin Controllers**: Like Django's thin views
7. **Single Responsibility**: Each object has one job

## 🆘 Common Pitfalls

### Pitfall 1: Service Objects Doing Too Much

```ruby
# Bad: God object
class UserService
  def create(params); end
  def update(params); end
  def delete(user); end
  def send_email(user); end
  def generate_report(user); end
end

# Good: Single responsibility
class Users::CreateService; end
class Users::UpdateService; end
class Users::DeleteService; end
class Users::SendEmailService; end
class Users::GenerateReportService; end
```

### Pitfall 2: Decorators with Business Logic

```ruby
# Bad: Business logic in decorator
class ProductDecorator < Draper::Decorator
  def discounted_price
    object.price * 0.9  # Business logic!
  end
end

# Good: Only presentation logic
class ProductDecorator < Draper::Decorator
  def formatted_price
    h.number_to_currency(object.price)
  end

  def discount_badge
    h.content_tag(:span, "#{object.discount_percent}% OFF")
  end
end
```

### Pitfall 3: Query Objects Returning Arrays

```ruby
# Bad: Returns array
class ProductsQuery
  def call
    Product.where(active: true).to_a  # Don't materialize!
  end
end

# Good: Returns relation
class ProductsQuery
  def call
    Product.where(active: true)  # Chainable
  end
end

# Usage: Can still chain
ProductsQuery.new.call.order(:name).limit(10)
```

## 📖 Additional Resources

### Design Patterns
- [Ruby Design Patterns](https://github.com/davidgf/design-patterns-in-ruby)
- [Refactoring Patterns in Ruby](https://www.refactoring.com/)
- [Draper Gem Documentation](https://github.com/drapergem/draper)

### Service Objects
- [Service Objects in Rails](https://www.toptal.com/ruby-on-rails/rails-service-objects-tutorial)
- [Interactor Gem](https://github.com/collectiveidea/interactor)

### Authorization
- [Pundit Documentation](https://github.com/varvet/pundit)
- [CanCanCan](https://github.com/CanCanCommunity/cancancan)

---

Ready to build clean architecture? Start with **[Exercise 1: Service Objects](exercises/1-service-objects.md)**! 🏗️
