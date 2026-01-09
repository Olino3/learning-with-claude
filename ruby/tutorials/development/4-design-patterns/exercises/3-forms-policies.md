# Exercise 3: Form Objects and Policy Objects

Practice building form objects for complex forms and policy objects for authorization.

## Part 1: Checkout Form Object

Build a form that handles user info, shipping, and payment.

```ruby
# app/forms/checkout_form.rb
class CheckoutForm
  include ActiveModel::Model

  # TODO: Implement checkout form that:
  # 1. Validates all fields
  # 2. Creates order, shipping address, payment
  # 3. Handles transaction atomically
  # 4. Returns success/failure
end
```

<details>
<summary>Solution</summary>

```ruby
class CheckoutForm
  include ActiveModel::Model

  attr_accessor :email, :phone
  attr_accessor :shipping_street, :shipping_city, :shipping_state, :shipping_zip
  attr_accessor :payment_method, :card_token
  attr_accessor :cart_id, :user_id

  validates :email, :phone, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :shipping_street, :shipping_city, :shipping_state, :shipping_zip, presence: true
  validates :payment_method, :card_token, presence: true

  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      create_order
      create_shipping_address
      process_payment
      clear_cart
    end

    true
  rescue StandardError => e
    errors.add(:base, e.message)
    false
  end

  attr_reader :order

  private

  def create_order
    @order = Order.create!(
      user_id: user_id,
      email: email,
      phone: phone,
      total: cart.total
    )
  end

  def create_shipping_address
    ShippingAddress.create!(
      order: order,
      street: shipping_street,
      city: shipping_city,
      state: shipping_state,
      zip_code: shipping_zip
    )
  end

  def process_payment
    Payments::ProcessService.new(
      order: order,
      payment_method: card_token
    ).call
  end

  def clear_cart
    cart.clear!
  end

  def cart
    @cart ||= Cart.find(cart_id)
  end
end
```
</details>

## Part 2: Blog Post Policy

Create comprehensive authorization policies.

<details>
<summary>Solution</summary>

```ruby
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

  def unpublish?
    owner? || admin?
  end

  def moderate?
    admin? || moderator?
  end

  private

  def owner?
    user && user == post.user
  end

  def admin?
    user&.admin?
  end

  def moderator?
    user&.moderator?
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
      elsif user&.moderator?
        scope.where(published: true)
             .or(scope.where(flagged: true))
      elsif user
        scope.where(published: true)
             .or(scope.where(user: user))
      else
        scope.where(published: true)
      end
    end
  end
end
```
</details>

## Key Learnings

- Form objects handle complex multi-model forms
- Policy objects centralize authorization
- Scopes filter collections by permissions
- Transaction ensure data consistency

## Congratulations!

You've completed all Design Patterns exercises!
