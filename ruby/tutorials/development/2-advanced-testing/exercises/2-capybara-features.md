# Exercise 2: Capybara Feature Testing

Practice browser automation and feature testing with Capybara.

## 🎯 Objectives

- Write feature tests that simulate user interactions
- Use Capybara DSL for navigation and form filling
- Test JavaScript interactions
- Write descriptive scenarios
- Organize feature tests effectively

## 📝 Part 1: User Authentication Flow

Test the complete authentication experience.

### User Registration

```ruby
# spec/features/user_registration_spec.rb
require 'rails_helper'

RSpec.feature 'User Registration', type: :feature do
  scenario 'User signs up with valid information' do
    visit root_path
    click_link 'Sign Up'

    expect(page).to have_current_path(signup_path)

    fill_in 'Email', with: 'newuser@example.com'
    fill_in 'Username', with: 'newuser'
    fill_in 'Password', with: 'password123'
    fill_in 'Password Confirmation', with: 'password123'

    click_button 'Create Account'

    expect(page).to have_content('Welcome! Please check your email to confirm your account.')
    expect(page).to have_current_path(root_path)
    expect(User.last.email).to eq('newuser@example.com')
  end

  scenario 'User sees errors with invalid data' do
    visit signup_path

    fill_in 'Email', with: 'invalid-email'
    fill_in 'Password', with: 'short'

    click_button 'Create Account'

    expect(page).to have_content('Email is invalid')
    expect(page).to have_content('Password is too short')
    expect(User.count).to eq(0)
  end

  scenario 'User cannot sign up with duplicate email' do
    create(:user, email: 'existing@example.com')

    visit signup_path

    fill_in 'Email', with: 'existing@example.com'
    fill_in 'Username', with: 'newuser'
    fill_in 'Password', with: 'password123'
    fill_in 'Password Confirmation', with: 'password123'

    click_button 'Create Account'

    expect(page).to have_content('Email has already been taken')
  end

  scenario 'Password and confirmation must match' do
    visit signup_path

    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: 'password123'
    fill_in 'Password Confirmation', with: 'different123'

    click_button 'Create Account'

    expect(page).to have_content("Password confirmation doesn't match")
  end
end
```

### User Login

```ruby
# spec/features/user_login_spec.rb
require 'rails_helper'

RSpec.feature 'User Login', type: :feature do
  let!(:user) { create(:user, :confirmed, email: 'user@example.com', password: 'password123') }

  scenario 'User logs in with valid credentials' do
    visit login_path

    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: 'password123'

    click_button 'Log In'

    expect(page).to have_content('Successfully logged in')
    expect(page).to have_link('Logout')
    expect(page).not_to have_link('Login')
  end

  scenario 'User cannot login with wrong password' do
    visit login_path

    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: 'wrongpassword'

    click_button 'Log In'

    expect(page).to have_content('Invalid email or password')
    expect(page).to have_current_path(login_path)
  end

  scenario 'Unconfirmed user cannot login' do
    unconfirmed = create(:user, email: 'unconfirmed@example.com', password: 'password123')

    visit login_path

    fill_in 'Email', with: 'unconfirmed@example.com'
    fill_in 'Password', with: 'password123'

    click_button 'Log In'

    expect(page).to have_content('Please confirm your email address first')
  end

  scenario 'User checks Remember Me' do
    visit login_path

    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: 'password123'
    check 'Remember Me'

    click_button 'Log In'

    expect(page).to have_content('Successfully logged in')
    # Check cookie was set
  end
end
```

### Password Reset

```ruby
# spec/features/password_reset_spec.rb
require 'rails_helper'

RSpec.feature 'Password Reset', type: :feature do
  let!(:user) { create(:user, :confirmed, email: 'user@example.com') }

  scenario 'User requests password reset' do
    visit login_path
    click_link 'Forgot Password?'

    expect(page).to have_current_path(forgot_password_path)

    fill_in 'Email', with: 'user@example.com'
    click_button 'Send Reset Instructions'

    expect(page).to have_content('Password reset instructions sent')
  end

  scenario 'User resets password with valid token' do
    token = user.generate_password_reset_token!

    visit password_reset_path(token: token)

    fill_in 'New Password', with: 'newpassword123'
    fill_in 'Confirm Password', with: 'newpassword123'

    click_button 'Reset Password'

    expect(page).to have_content('Password successfully reset')
    expect(page).to have_current_path(login_path)
  end

  scenario 'User cannot reset with expired token' do
    token = user.generate_password_reset_token!
    user.update(password_reset_sent_at: 3.hours.ago)  # Expire it

    visit password_reset_path(token: token)

    fill_in 'New Password', with: 'newpassword123'
    fill_in 'Confirm Password', with: 'newpassword123'

    click_button 'Reset Password'

    expect(page).to have_content('Password reset link has expired')
  end
end
```

## 📝 Part 2: Blog Post Management

Your Task: Implement these feature tests.

```ruby
# spec/features/blog_post_management_spec.rb
require 'rails_helper'

RSpec.feature 'Blog Post Management', type: :feature do
  let(:author) { create(:user, :confirmed) }

  background do
    # Login helper
    login_as(author)
  end

  scenario 'Author creates a new blog post' do
    # TODO: Implement
    # - Visit new post page
    # - Fill in title and body
    # - Select category
    # - Upload featured image (optional)
    # - Check "Publish immediately"
    # - Submit form
    # - Verify success message
    # - Verify post appears on blog
  end

  scenario 'Author saves post as draft' do
    # TODO: Implement
    # - Create post without checking "Publish"
    # - Verify it's saved as draft
    # - Verify it doesn't appear on public blog
    # - Verify it appears in drafts section
  end

  scenario 'Author edits existing post' do
    # TODO: Implement
    # - Create a post
    # - Visit post page
    # - Click Edit
    # - Change title and body
    # - Save changes
    # - Verify updates appear
  end

  scenario 'Author deletes their post', js: true do
    # TODO: Implement
    # - Create a post
    # - Visit post page
    # - Click Delete
    # - Confirm deletion in modal
    # - Verify success message
    # - Verify post no longer exists
  end

  scenario 'Author cannot delete another user\'s post' do
    # TODO: Implement
    # - Create post by different author
    # - Try to visit edit page
    # - Verify access denied
  end

  scenario 'Author previews post before publishing' do
    # TODO: Implement
    # - Fill in post form
    # - Click Preview
    # - Verify preview shows formatted content
    # - Verify can go back to edit
  end
end
```

## 📝 Part 3: E-Commerce Shopping Cart

Test the complete shopping experience.

```ruby
# spec/features/shopping_cart_spec.rb
require 'rails_helper'

RSpec.feature 'Shopping Cart', type: :feature do
  let!(:product1) { create(:product, name: 'Ruby Book', price: 29.99, stock: 10) }
  let!(:product2) { create(:product, name: 'Rails Guide', price: 39.99, stock: 5) }
  let(:user) { create(:user, :confirmed) }

  scenario 'Guest adds products to cart' do
    visit products_path

    within("#product-#{product1.id}") do
      click_button 'Add to Cart'
    end

    expect(page).to have_content('Added to cart')
    expect(page).to have_css('.cart-count', text: '1')

    click_link 'Cart'

    expect(page).to have_content('Ruby Book')
    expect(page).to have_content('$29.99')
  end

  scenario 'User updates quantity in cart', js: true do
    visit product_path(product1)
    click_button 'Add to Cart'

    visit cart_path

    within('.cart-item') do
      fill_in 'Quantity', with: '3'
    end

    # Wait for AJAX update
    expect(page).to have_content('$89.97')  # 29.99 * 3
  end

  scenario 'User removes item from cart' do
    visit product_path(product1)
    click_button 'Add to Cart'

    visit cart_path

    within('.cart-item') do
      click_link 'Remove'
    end

    expect(page).to have_content('Your cart is empty')
  end

  scenario 'User applies discount code' do
    create(:discount_code, code: 'SAVE20', discount_percent: 20)

    visit product_path(product1)
    click_button 'Add to Cart'

    visit cart_path

    fill_in 'Discount Code', with: 'SAVE20'
    click_button 'Apply'

    expect(page).to have_content('Discount applied: 20% off')
    expect(page).to have_content('$23.99')  # 29.99 - 20%
  end

  scenario 'User cannot add more items than in stock' do
    visit product_path(product2)  # Stock: 5

    fill_in 'Quantity', with: '10'
    click_button 'Add to Cart'

    expect(page).to have_content('Only 5 items available')
  end

  scenario 'User completes checkout', js: true do
    login_as(user)

    visit product_path(product1)
    click_button 'Add to Cart'

    visit cart_path
    click_button 'Proceed to Checkout'

    # Shipping information
    fill_in 'Address', with: '123 Main St'
    fill_in 'City', with: 'Portland'
    select 'Oregon', from: 'State'
    fill_in 'ZIP', with: '97201'

    click_button 'Continue to Payment'

    # Payment information (using test card)
    within_frame('stripe-card-iframe') do
      fill_in 'Card number', with: '4242424242424242'
      fill_in 'Expiry', with: '12/25'
      fill_in 'CVC', with: '123'
    end

    click_button 'Place Order'

    expect(page).to have_content('Order confirmed!')
    expect(page).to have_content('Order #')
    expect(Order.last.user).to eq(user)
  end
end
```

## 📝 Part 4: Admin Dashboard

Test admin-only features.

```ruby
# spec/features/admin/user_management_spec.rb
require 'rails_helper'

RSpec.feature 'Admin User Management', type: :feature do
  let(:admin) { create(:user, :admin) }
  let!(:users) { create_list(:user, 10) }

  background do
    login_as(admin)
    visit admin_users_path
  end

  scenario 'Admin views all users' do
    expect(page).to have_css('table.users tbody tr', count: 11)  # 10 + admin
  end

  scenario 'Admin searches for users' do
    user = users.first

    fill_in 'Search', with: user.email
    click_button 'Search'

    expect(page).to have_content(user.email)
    expect(page).to have_css('table.users tbody tr', count: 1)
  end

  scenario 'Admin filters users by role' do
    create_list(:user, 3, :admin)

    select 'Admin', from: 'Role'
    click_button 'Filter'

    expect(page).to have_css('table.users tbody tr', count: 4)  # 3 + original admin
  end

  scenario 'Admin bans a user', js: true do
    user = users.first

    within("#user-#{user.id}") do
      click_link 'Ban'
    end

    within('.modal') do
      fill_in 'Reason', with: 'Violated terms of service'
      click_button 'Confirm Ban'
    end

    expect(page).to have_content('User banned successfully')

    within("#user-#{user.id}") do
      expect(page).to have_css('.badge-banned')
    end
  end

  scenario 'Non-admin cannot access admin dashboard' do
    logout
    login_as(create(:user))

    visit admin_users_path

    expect(page).to have_content('Access Denied')
    expect(page).to have_current_path(root_path)
  end
end
```

## 📝 Part 5: JavaScript Interactions

Test dynamic behavior.

```ruby
# spec/features/interactive_comments_spec.rb
require 'rails_helper'

RSpec.feature 'Interactive Comments', type: :feature, js: true do
  let(:user) { create(:user, :confirmed) }
  let(:post) { create(:post, :published) }

  background do
    login_as(user)
    visit post_path(post)
  end

  scenario 'User adds a comment' do
    fill_in 'Comment', with: 'Great post!'
    click_button 'Post Comment'

    # Wait for AJAX
    within('.comments') do
      expect(page).to have_content('Great post!')
      expect(page).to have_content(user.username)
      expect(page).to have_content('just now')
    end
  end

  scenario 'User edits their comment' do
    comment = create(:comment, post: post, user: user, body: 'Original comment')

    visit post_path(post)

    within("#comment-#{comment.id}") do
      click_link 'Edit'
      fill_in 'Comment', with: 'Updated comment'
      click_button 'Save'
    end

    within("#comment-#{comment.id}") do
      expect(page).to have_content('Updated comment')
      expect(page).to have_content('(edited)')
    end
  end

  scenario 'User deletes their comment' do
    comment = create(:comment, post: post, user: user)

    visit post_path(post)

    within("#comment-#{comment.id}") do
      accept_confirm do
        click_link 'Delete'
      end
    end

    expect(page).not_to have_css("#comment-#{comment.id}")
  end

  scenario 'User replies to a comment' do
    parent_comment = create(:comment, post: post)

    visit post_path(post)

    within("#comment-#{parent_comment.id}") do
      click_link 'Reply'
      fill_in 'Reply', with: 'My reply'
      click_button 'Post Reply'
    end

    within('.replies') do
      expect(page).to have_content('My reply')
    end
  end

  scenario 'User likes a comment' do
    comment = create(:comment, post: post)

    visit post_path(post)

    within("#comment-#{comment.id}") do
      click_button 'Like'
      expect(page).to have_content('1 like')
      expect(page).to have_css('.liked')
    end
  end
end
```

## 🎯 Challenge: Complete Feature Test Suite

Create comprehensive feature tests for:

1. **User Profile Management**
   - View profile
   - Edit profile (name, bio, avatar)
   - Change password
   - Privacy settings
   - Delete account

2. **Search Functionality**
   - Search posts by keyword
   - Filter by category
   - Sort results (relevance, date, popularity)
   - Autocomplete suggestions
   - No results handling

3. **Notifications**
   - Receive notifications for comments, likes, follows
   - Mark as read
   - View all notifications
   - Delete notifications
   - Real-time updates (WebSockets)

4. **File Uploads**
   - Upload avatar
   - Upload multiple images for post
   - Drag and drop support
   - Image preview before upload
   - File size and type validation

## 🐍 Python Comparison

```python
# Python (Selenium)
from selenium import webdriver
from selenium.webdriver.common.by import By

def test_user_login():
    driver = webdriver.Chrome()
    driver.get('http://localhost:3000/login')

    email_input = driver.find_element(By.ID, 'email')
    email_input.send_keys('user@example.com')

    password_input = driver.find_element(By.ID, 'password')
    password_input.send_keys('password123')

    submit = driver.find_element(By.ID, 'submit')
    submit.click()

    assert 'Welcome' in driver.page_source
```

```ruby
# Ruby (Capybara)
RSpec.feature 'User Login' do
  scenario 'with valid credentials' do
    visit login_path

    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: 'password123'

    click_button 'Log In'

    expect(page).to have_content('Welcome')
  end
end
```

## ✅ Success Criteria

- [ ] Wrote user registration tests
- [ ] Wrote login/logout tests
- [ ] Tested password reset flow
- [ ] Tested shopping cart functionality
- [ ] Wrote admin dashboard tests
- [ ] Tested JavaScript interactions
- [ ] Used descriptive scenario names
- [ ] Organized tests logically

## 💡 Tips

1. **Use descriptive scenario names** that read like user stories
2. **Keep scenarios focused** - one user action per scenario
3. **Use backgrounds** for common setup
4. **Test happy path and edge cases**
5. **Use page objects** for complex pages (advanced)
6. **Avoid sleep** - use Capybara's waiting behavior
7. **Test critical paths** - don't test everything with features

## 📖 Capybara Helpers

Create helper methods for common actions:

```ruby
# spec/support/feature_helpers.rb
module FeatureHelpers
  def login_as(user, password: 'password123')
    visit login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: password
    click_button 'Log In'
  end

  def logout
    click_link 'Logout'
  end

  def add_to_cart(product, quantity: 1)
    visit product_path(product)
    fill_in 'Quantity', with: quantity if quantity != 1
    click_button 'Add to Cart'
  end
end

RSpec.configure do |config|
  config.include FeatureHelpers, type: :feature
end
```

---

**Feature tests ensure your app works from the user's perspective!** 🎭
