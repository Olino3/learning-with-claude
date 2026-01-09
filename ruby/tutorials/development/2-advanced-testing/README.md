# Tutorial 2: Advanced Testing - FactoryBot & Capybara

Take your testing to the next level with advanced tools for generating test data and simulating user interactions. This tutorial covers FactoryBot for dynamic test data and Capybara for feature testing web applications.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Generate dynamic test data with FactoryBot
- Use traits, sequences, and associations
- Write feature tests with Capybara
- Simulate user interactions in web applications
- Understand test doubles, mocks, and stubs
- Write integration tests effectively
- Know when to use unit vs integration vs feature tests
- Master RSpec mocks and stubbing

## 🐍➡️🔴 Coming from Python

If you're familiar with Python testing tools, here's how Ruby's advanced testing compares:

| Concept | Python | Ruby | Key Difference |
|---------|--------|------|----------------|
| Test data factories | factory_boy | FactoryBot | Very similar syntax |
| Browser automation | Selenium | Capybara | Capybara more Ruby-idiomatic |
| Test fixtures | pytest fixtures | FactoryBot factories | FactoryBot is dynamic |
| Mocking | unittest.mock | rspec-mocks | Similar capabilities |
| Stubbing | unittest.mock.patch | allow/receive | Different syntax |
| Feature tests | Behave/pytest-bdd | Capybara | Capybara simpler setup |
| Database cleaning | pytest-django | DatabaseCleaner | Similar purpose |
| Headless browser | Selenium headless | Selenium/Rack::Test | Multiple drivers |

> **📘 Python Note:** FactoryBot is like factory_boy, and Capybara is like Selenium but with a more readable DSL designed for Ruby.

## 📝 Part 1: FactoryBot - Dynamic Test Data

### Why FactoryBot?

```ruby
# Without FactoryBot: Manual test data 😰
user = User.new(
  email: 'test@example.com',
  password: 'password123',
  first_name: 'John',
  last_name: 'Doe',
  age: 30,
  role: 'user',
  confirmed: true,
  created_at: Time.now
)
user.save!

# With FactoryBot: Clean and DRY 🎉
user = create(:user)
```

### Installing FactoryBot

```ruby
# Gemfile
group :test do
  gem 'factory_bot'
  gem 'faker'  # For realistic fake data
end

# spec/spec_helper.rb
require 'factory_bot'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
```

### Your First Factory

```ruby
# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    email { "user#{rand(1000)}@example.com" }
    password { 'password123' }
    first_name { 'John' }
    last_name { 'Doe' }
    age { 30 }
    role { 'user' }
    confirmed { true }
  end
end

# Usage in tests
RSpec.describe User do
  it 'creates a user with factory' do
    user = create(:user)
    expect(user.email).to match(/@example.com/)
  end
end
```

> **📘 Python Note:** This is like `factory_boy` in Python:
> ```python
> class UserFactory(factory.Factory):
>     class Meta:
>         model = User
>     email = factory.Sequence(lambda n: f'user{n}@example.com')
> ```

### Using Faker for Realistic Data

```ruby
# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 8) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    age { rand(18..80) }
    bio { Faker::Lorem.paragraph }
    phone { Faker::PhoneNumber.phone_number }
  end
end
```

### Sequences

```ruby
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:username) { |n| "user#{n}" }

    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
  end
end

# Creates unique emails: user1@example.com, user2@example.com, etc.
user1 = create(:user)  # user1@example.com
user2 = create(:user)  # user2@example.com
```

### Traits - Variations of Factories

```ruby
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password123' }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    role { 'user' }
    confirmed { false }

    # Admin user trait
    trait :admin do
      role { 'admin' }
      confirmed { true }
    end

    # Confirmed user trait
    trait :confirmed do
      confirmed { true }
      confirmed_at { Time.now }
    end

    # Premium user trait
    trait :premium do
      subscription { 'premium' }
      subscription_expires_at { 1.year.from_now }
    end

    # Banned user trait
    trait :banned do
      banned { true }
      banned_at { Time.now }
      ban_reason { 'Violated terms of service' }
    end
  end
end

# Usage
admin = create(:user, :admin)
confirmed_user = create(:user, :confirmed)
premium_admin = create(:user, :admin, :premium)
banned_user = create(:user, :banned)
```

### Associations

```ruby
# spec/factories/posts.rb
FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraphs(number: 3).join("\n\n") }
    published { false }

    # Association with user
    association :author, factory: :user

    trait :published do
      published { true }
      published_at { Time.now }
    end
  end
end

# spec/factories/comments.rb
FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.paragraph }

    association :post
    association :user
  end
end

# Usage
post = create(:post)  # Also creates a user as author
comment = create(:comment)  # Creates user, post, and comment

# Explicit associations
user = create(:user)
post = create(:post, author: user)
comment = create(:comment, post: post, user: user)
```

### Transient Attributes

```ruby
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password123' }

    # Transient attribute (not saved to database)
    transient do
      posts_count { 0 }
    end

    # After creation callback
    after(:create) do |user, evaluator|
      create_list(:post, evaluator.posts_count, author: user)
    end
  end
end

# Usage
user_with_posts = create(:user, posts_count: 5)
expect(user_with_posts.posts.count).to eq(5)
```

### Build Strategies

```ruby
# build: Creates object in memory (not saved)
user = build(:user)
user.new_record?  # => true

# create: Creates and saves object
user = create(:user)
user.persisted?  # => true

# build_stubbed: Creates a stubbed object (fast!)
user = build_stubbed(:user)
user.id  # => Generated ID, but not in database

# attributes_for: Returns hash of attributes
attrs = attributes_for(:user)
# => { email: "...", first_name: "...", ... }

# create_list: Create multiple objects
users = create_list(:user, 3)
users.length  # => 3

# build_list: Build multiple objects
users = build_list(:user, 5)
```

### Complete Factory Example

```ruby
# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:username) { |n| "user#{n}" }
    password { Faker::Internet.password(min_length: 8) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    age { rand(18..80) }
    bio { Faker::Lorem.paragraph }
    confirmed { false }
    role { 'user' }

    trait :confirmed do
      confirmed { true }
      confirmed_at { Time.now }
    end

    trait :admin do
      role { 'admin' }
      confirmed { true }
    end

    trait :with_posts do
      transient do
        posts_count { 3 }
      end

      after(:create) do |user, evaluator|
        create_list(:post, evaluator.posts_count, author: user)
      end
    end

    factory :admin_user, traits: [:admin]
    factory :confirmed_user, traits: [:confirmed]
  end
end

# Usage
regular_user = create(:user)
admin = create(:admin_user)
confirmed = create(:confirmed_user)
blogger = create(:user, :with_posts, posts_count: 10)
```

## 📝 Part 2: Capybara - Feature Testing

Capybara simulates how a real user interacts with your web application.

### Installing Capybara

```ruby
# Gemfile
group :test do
  gem 'capybara'
  gem 'selenium-webdriver'  # For JavaScript testing
end

# spec/spec_helper.rb
require 'capybara/rspec'

Capybara.configure do |config|
  config.default_driver = :rack_test  # Fast, no JS
  config.javascript_driver = :selenium_chrome_headless  # For JS tests
end
```

### Your First Feature Test

```ruby
# spec/features/user_login_spec.rb
require 'rails_helper'

RSpec.feature 'User Login', type: :feature do
  let(:user) { create(:user, :confirmed, password: 'password123') }

  scenario 'User logs in with valid credentials' do
    # Visit the login page
    visit login_path

    # Fill in the form
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password123'

    # Click the submit button
    click_button 'Log In'

    # Assertions
    expect(page).to have_content('Welcome back!')
    expect(page).to have_current_path(dashboard_path)
  end

  scenario 'User sees error with invalid credentials' do
    visit login_path

    fill_in 'Email', with: 'wrong@example.com'
    fill_in 'Password', with: 'wrongpassword'

    click_button 'Log In'

    expect(page).to have_content('Invalid email or password')
    expect(page).to have_current_path(login_path)
  end
end
```

> **📘 Python Note:** This is similar to Selenium in Python, but with cleaner syntax:
> ```python
> driver.get(login_url)
> driver.find_element(By.ID, 'email').send_keys(user.email)
> driver.find_element(By.ID, 'submit').click()
> ```

### Capybara DSL Methods

```ruby
# Navigation
visit('/posts')
visit post_path(post)

# Clicking
click_link 'About Us'
click_button 'Submit'
click_on 'Login'  # Works for links or buttons

# Forms
fill_in 'Email', with: 'user@example.com'
fill_in 'user[email]', with: 'user@example.com'  # By name attribute

choose 'Male'  # Radio button
check 'Terms of Service'  # Checkbox
uncheck 'Subscribe to newsletter'
select 'Ruby', from: 'Language'  # Dropdown

attach_file 'Avatar', '/path/to/image.jpg'

# Assertions
expect(page).to have_content('Welcome')
expect(page).to have_text('Hello')
expect(page).to have_css('.alert-success')
expect(page).to have_selector('h1', text: 'Dashboard')
expect(page).to have_link('Logout')
expect(page).to have_button('Submit')
expect(page).to have_field('Email')
expect(page).to have_current_path('/dashboard')

# Negative assertions
expect(page).not_to have_content('Error')
expect(page).not_to have_css('.alert-danger')

# Scoping
within('.user-profile') do
  expect(page).to have_content(user.name)
  click_link 'Edit'
end

within_table('users') do
  expect(page).to have_content(user.email)
end

# JavaScript interactions (requires JS driver)
page.execute_script('window.scrollTo(0, 500)')
page.evaluate_script('document.title')

# Debugging
save_and_open_page  # Opens browser with current page
save_screenshot('screenshot.png')
```

### Complete Feature Test Example

```ruby
# spec/features/blog_post_management_spec.rb
require 'rails_helper'

RSpec.feature 'Blog Post Management', type: :feature do
  let(:author) { create(:user, :confirmed) }

  background do
    # Login before each scenario
    visit login_path
    fill_in 'Email', with: author.email
    fill_in 'Password', with: 'password123'
    click_button 'Log In'
  end

  scenario 'Author creates a new blog post' do
    visit new_post_path

    fill_in 'Title', with: 'My First Post'
    fill_in 'Body', with: 'This is the content of my post.'
    select 'Technology', from: 'Category'
    check 'Published'

    click_button 'Create Post'

    expect(page).to have_content('Post created successfully')
    expect(page).to have_content('My First Post')
    expect(Post.count).to eq(1)
  end

  scenario 'Author edits their post' do
    post = create(:post, author: author, title: 'Original Title')

    visit edit_post_path(post)

    fill_in 'Title', with: 'Updated Title'
    click_button 'Update Post'

    expect(page).to have_content('Post updated successfully')
    expect(page).to have_content('Updated Title')
    expect(post.reload.title).to eq('Updated Title')
  end

  scenario 'Author deletes their post', js: true do
    post = create(:post, author: author)

    visit post_path(post)

    accept_confirm do
      click_link 'Delete Post'
    end

    expect(page).to have_content('Post deleted')
    expect(Post.exists?(post.id)).to be false
  end

  scenario 'Author cannot edit another user\'s post' do
    other_user = create(:user)
    other_post = create(:post, author: other_user)

    visit edit_post_path(other_post)

    expect(page).to have_content('Access Denied')
    expect(page).to have_current_path(root_path)
  end
end
```

## 📝 Part 3: Test Doubles, Mocks, and Stubs

### Stubs - Canned Responses

```ruby
# Stub a method to return a specific value
user = double('User')
allow(user).to receive(:name).and_return('Alice')

expect(user.name).to eq('Alice')
```

### Mocks - Expectations

```ruby
# Mock: Expect a method to be called
mailer = double('Mailer')
expect(mailer).to receive(:send_email).with('user@example.com')

# This will fail if send_email is not called
mailer.send_email('user@example.com')
```

### Real-World Example

```ruby
RSpec.describe OrderProcessor do
  describe '#process' do
    let(:order) { create(:order) }
    let(:payment_gateway) { instance_double('PaymentGateway') }
    let(:mailer) { instance_double('OrderMailer') }

    it 'charges payment and sends confirmation email' do
      # Stub the payment gateway
      allow(payment_gateway).to receive(:charge)
        .with(order.total)
        .and_return({ success: true, transaction_id: '12345' })

      # Expect email to be sent
      expect(mailer).to receive(:send_confirmation)
        .with(order)

      processor = OrderProcessor.new(
        payment_gateway: payment_gateway,
        mailer: mailer
      )

      result = processor.process(order)

      expect(result).to be_success
      expect(order.reload.status).to eq('paid')
    end

    it 'handles payment failure gracefully' do
      # Stub payment failure
      allow(payment_gateway).to receive(:charge)
        .and_return({ success: false, error: 'Insufficient funds' })

      # Expect NO email sent
      expect(mailer).not_to receive(:send_confirmation)

      processor = OrderProcessor.new(
        payment_gateway: payment_gateway,
        mailer: mailer
      )

      result = processor.process(order)

      expect(result).to be_failure
      expect(order.reload.status).to eq('failed')
    end
  end
end
```

### Spy - Verify After the Fact

```ruby
# Spy: Like a mock, but verified after execution
logger = spy('Logger')

# Call methods
logger.info('Started processing')
logger.debug('Processing item 1')
logger.info('Completed')

# Verify after
expect(logger).to have_received(:info).with('Started processing')
expect(logger).to have_received(:debug).once
expect(logger).to have_received(:info).twice
```

### Partial Doubles

```ruby
# Stub specific methods on real objects
user = create(:user)

allow(user).to receive(:admin?).and_return(true)

expect(user.admin?).to be true  # Stubbed
expect(user.email).to match(/@/)  # Real method
```

## 📝 Integration Testing Best Practices

### Test Pyramid

```
         /\
        /  \  E2E (Feature Tests with Capybara)
       /____\
      /      \
     / Integration Tests
    /________________\
   /                  \
  /   Unit Tests       \
 /______________________\
```

- **Unit Tests (70%)**: Fast, isolated, test single units
- **Integration Tests (20%)**: Test components working together
- **E2E/Feature Tests (10%)**: Slow, test full user workflows

### Unit Test Example

```ruby
RSpec.describe User do
  describe '#full_name' do
    it 'combines first and last name' do
      user = User.new(first_name: 'John', last_name: 'Doe')
      expect(user.full_name).to eq('John Doe')
    end
  end
end
```

### Integration Test Example

```ruby
RSpec.describe 'Order Processing' do
  it 'creates order with items and calculates total' do
    user = create(:user)
    product1 = create(:product, price: 10.00)
    product2 = create(:product, price: 15.00)

    order = Order.create(user: user)
    order.add_item(product1, quantity: 2)
    order.add_item(product2, quantity: 1)

    expect(order.items.count).to eq(2)
    expect(order.total).to eq(35.00)
    expect(order.user).to eq(user)
  end
end
```

### Feature Test Example

```ruby
RSpec.feature 'Complete Purchase Flow' do
  scenario 'User purchases products' do
    product = create(:product, name: 'Ruby Book', price: 29.99)

    visit products_path
    click_link 'Ruby Book'
    click_button 'Add to Cart'

    visit cart_path
    click_button 'Checkout'

    fill_in 'Card Number', with: '4242424242424242'
    click_button 'Complete Purchase'

    expect(page).to have_content('Order confirmed!')
    expect(Order.last.status).to eq('paid')
  end
end
```

## ✍️ Exercises

### Exercise 1: FactoryBot Practice
👉 **[FactoryBot Factories](exercises/1-factorybot-practice.md)**

Practice creating factories with:
- Sequences and Faker
- Traits and associations
- Transient attributes
- Build strategies

### Exercise 2: Capybara Feature Tests
👉 **[Capybara Feature Testing](exercises/2-capybara-features.md)**

Write feature tests for:
- User registration flow
- Blog post CRUD operations
- Shopping cart functionality
- Admin dashboard

### Exercise 3: Mocking External Services
👉 **[Mocks and Stubs](exercises/3-mocking-external-services.md)**

Practice mocking:
- Payment gateways
- Email services
- External APIs
- File system operations

## 📚 What You Learned

✅ Dynamic test data generation with FactoryBot
✅ Traits, sequences, and associations
✅ Feature testing with Capybara
✅ Simulating user interactions
✅ Test doubles, mocks, and stubs
✅ Integration vs unit vs feature testing
✅ When to use each testing approach
✅ Best practices for test organization

## 🔜 Next Steps

**Next: [Tutorial 3: Code Quality Tools (RuboCop & StandardRB)](../3-code-quality/README.md)**

Learn to:
- Enforce Ruby style guidelines
- Auto-format code with RuboCop
- Use StandardRB for zero-config linting
- Integrate linting into CI/CD

## 💡 Key Takeaways for Python Developers

1. **FactoryBot ≈ factory_boy**: Very similar syntax and capabilities
2. **Capybara ≈ Selenium**: But more Ruby-idiomatic and readable
3. **Traits**: Like factory_boy traits, define variations easily
4. **Sequences**: Ensure unique values (like factory.Sequence)
5. **RSpec mocks ≈ unittest.mock**: Different syntax, same concepts
6. **Test pyramid**: Same principle as Python testing
7. **Feature tests**: Use sparingly, they're slow but valuable

## 🆘 Common Pitfalls

### Pitfall 1: Creating Too Much Test Data

```ruby
# Bad: Creating unnecessary objects
user = create(:user, :with_posts, posts_count: 100)  # Slow!

# Good: Create minimal data
user = build_stubbed(:user)  # Fast, not saved
# or
user = build(:user)  # In-memory only
```

### Pitfall 2: Testing Implementation Details in Features

```ruby
# Bad: Too implementation-focused
scenario 'creates post' do
  visit new_post_path
  # ...
  expect(Post.count).to eq(1)  # Don't check database in features
end

# Good: Test user-visible behavior
scenario 'creates post' do
  visit new_post_path
  # ...
  expect(page).to have_content('Post created successfully')
  expect(page).to have_content(post_title)
end
```

### Pitfall 3: Overusing Mocks

```ruby
# Bad: Mocking everything
user = double('User')
allow(user).to receive(:email).and_return('test@example.com')
allow(user).to receive(:name).and_return('Test')
# ... 20 more mocks

# Good: Use real objects when possible
user = build_stubbed(:user)  # Real User object, stubbed DB
```

### Pitfall 4: Slow Feature Tests

```ruby
# Bad: Feature test for simple validation
scenario 'validates email format' do
  visit signup_path
  fill_in 'Email', with: 'invalid'
  click_button 'Sign Up'
  expect(page).to have_content('Invalid email')
end

# Good: Unit test for validation
it 'validates email format' do
  user = build(:user, email: 'invalid')
  expect(user).not_to be_valid
  expect(user.errors[:email]).to include('is invalid')
end
```

## 📖 Additional Resources

### FactoryBot
- [FactoryBot Documentation](https://github.com/thoughtbot/factory_bot)
- [FactoryBot Rails Guide](https://github.com/thoughtbot/factory_bot_rails)
- [Faker Documentation](https://github.com/faker-ruby/faker)

### Capybara
- [Capybara Documentation](https://github.com/teamcapybara/capybara)
- [Capybara Cheatsheet](https://devhints.io/capybara)
- [Testing Rails Applications (Capybara)](https://guides.rubyonrails.org/testing.html#system-testing)

### Mocking
- [RSpec Mocks](https://rspec.info/features/3-12/rspec-mocks/)
- [Testing with Doubles](https://relishapp.com/rspec/rspec-mocks/docs)

---

Ready to practice? Start with **[Exercise 1: FactoryBot Practice](exercises/1-factorybot-practice.md)**! 🧪
