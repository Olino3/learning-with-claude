# Exercise 1: FactoryBot Practice

Master dynamic test data generation with FactoryBot.

## 🎯 Objectives

- Create factories with sequences and Faker
- Define traits for common variations
- Set up associations between models
- Use transient attributes
- Apply different build strategies

## 📝 Part 1: Blog Application Factories

Create factories for a blog application with users, posts, comments, and tags.

### Step 1: User Factory

```ruby
# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:username) { |n| "user#{n}" }
    password { Faker::Internet.password(min_length: 8) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    bio { Faker::Lorem.paragraph }
    role { 'member' }
    confirmed { false }

    trait :confirmed do
      confirmed { true }
      confirmed_at { Faker::Time.between(from: 30.days.ago, to: Time.now) }
    end

    trait :admin do
      role { 'admin' }
      confirmed { true }
    end

    trait :moderator do
      role { 'moderator' }
      confirmed { true }
    end

    trait :with_avatar do
      avatar_url { Faker::Avatar.image }
    end

    trait :with_posts do
      transient do
        posts_count { 3 }
      end

      after(:create) do |user, evaluator|
        create_list(:post, evaluator.posts_count, author: user)
      end
    end

    # Convenient factory aliases
    factory :admin_user, traits: [:admin]
    factory :moderator_user, traits: [:moderator]
  end
end
```

### Step 2: Post Factory

```ruby
# spec/factories/posts.rb
FactoryBot.define do
  factory :post do
    title { Faker::Book.title }
    body { Faker::Lorem.paragraphs(number: 5).join("\n\n") }
    published { false }
    views_count { 0 }

    association :author, factory: :user

    trait :published do
      published { true }
      published_at { Faker::Time.between(from: 30.days.ago, to: Time.now) }
    end

    trait :draft do
      published { false }
      published_at { nil }
    end

    trait :popular do
      views_count { rand(1000..10000) }
      published { true }
      published_at { rand(7..30).days.ago }
    end

    trait :recent do
      published { true }
      published_at { rand(1..3).days.ago }
    end

    trait :with_comments do
      transient do
        comments_count { 5 }
      end

      after(:create) do |post, evaluator|
        create_list(:comment, evaluator.comments_count, post: post)
      end
    end

    trait :with_tags do
      transient do
        tags_count { 3 }
      end

      after(:create) do |post, evaluator|
        create_list(:tag, evaluator.tags_count, posts: [post])
      end
    end
  end
end
```

### Step 3: Comment Factory

```ruby
# spec/factories/comments.rb
FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.paragraph }
    approved { true }

    association :post
    association :user

    trait :pending do
      approved { false }
    end

    trait :flagged do
      flagged { true }
      flagged_at { Time.now }
      flag_reason { 'Spam' }
    end

    trait :with_replies do
      transient do
        replies_count { 3 }
      end

      after(:create) do |comment, evaluator|
        create_list(:comment, evaluator.replies_count,
                    post: comment.post,
                    parent_id: comment.id)
      end
    end
  end
end
```

### Step 4: Tag Factory

```ruby
# spec/factories/tags.rb
FactoryBot.define do
  factory :tag do
    sequence(:name) { |n| "#{Faker::Hacker.noun}#{n}" }
    color { Faker::Color.hex_color }

    trait :popular do
      transient do
        posts_count { 10 }
      end

      after(:create) do |tag, evaluator|
        create_list(:post, evaluator.posts_count, :published, tags: [tag])
      end
    end
  end
end
```

## 📝 Part 2: E-Commerce Factories

Create factories for products, orders, and customers.

### Your Task: Implement These Factories

```ruby
# spec/factories/products.rb
FactoryBot.define do
  factory :product do
    # TODO: Implement
    # - name (use Faker::Commerce.product_name)
    # - description
    # - price (decimal)
    # - stock_quantity
    # - sku (unique)
    # - category

    # Traits:
    # - :in_stock
    # - :out_of_stock
    # - :on_sale (with sale_price)
    # - :featured
    # - :digital (no shipping required)
  end
end

# spec/factories/orders.rb
FactoryBot.define do
  factory :order do
    # TODO: Implement
    # - order_number (unique sequence)
    # - status ('pending', 'paid', 'shipped', 'delivered', 'cancelled')
    # - total_amount
    # - association :customer, factory: :user

    # Traits:
    # - :paid
    # - :shipped
    # - :delivered
    # - :cancelled
    # - :with_items (3 order items by default)
    # - :with_payment
  end
end

# spec/factories/order_items.rb
FactoryBot.define do
  factory :order_item do
    # TODO: Implement
    # - quantity
    # - unit_price
    # - association :order
    # - association :product
  end
end
```

## 📝 Part 3: Using Factories in Tests

Write tests using your factories:

```ruby
# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'requires unique email' do
      create(:user, email: 'test@example.com')
      duplicate = build(:user, email: 'test@example.com')
      expect(duplicate).not_to be_valid
    end
  end

  describe 'associations' do
    it 'has many posts' do
      user = create(:user, :with_posts, posts_count: 5)
      expect(user.posts.count).to eq(5)
    end
  end

  describe '#full_name' do
    it 'combines first and last name' do
      user = build(:user, first_name: 'John', last_name: 'Doe')
      expect(user.full_name).to eq('John Doe')
    end
  end

  describe 'scopes' do
    it 'finds confirmed users' do
      create_list(:user, 3, :confirmed)
      create_list(:user, 2)

      expect(User.confirmed.count).to eq(3)
    end

    it 'finds admins' do
      create_list(:user, 2, :admin)
      create_list(:user, 3)

      expect(User.admins.count).to eq(2)
    end
  end
end
```

### Your Task: Write Tests for Post Model

```ruby
# spec/models/post_spec.rb
require 'rails_helper'

RSpec.describe Post do
  describe 'validations' do
    # TODO: Test that post requires title and body
    # TODO: Test that post belongs to an author
  end

  describe 'associations' do
    # TODO: Test that post has many comments
    # TODO: Test that post has many tags
  end

  describe 'scopes' do
    # TODO: Test .published scope
    # TODO: Test .recent scope (posts from last 7 days)
    # TODO: Test .popular scope (posts with > 100 views)
  end

  describe '#publish!' do
    # TODO: Test that unpublished post can be published
    # TODO: Test that published_at is set
    # TODO: Test that already published post doesn't change
  end

  describe '#reading_time' do
    # TODO: Test calculation of reading time (250 words/minute)
  end
end
```

## 📝 Part 4: Advanced Factory Techniques

### Nested Attributes

```ruby
FactoryBot.define do
  factory :order do
    customer { association :user }
    status { 'pending' }

    transient do
      items_attributes { [] }
    end

    trait :with_custom_items do
      after(:build) do |order, evaluator|
        evaluator.items_attributes.each do |item_attrs|
          order.order_items.build(item_attrs)
        end
      end
    end
  end
end

# Usage
order = build(:order, :with_custom_items,
  items_attributes: [
    { product: product1, quantity: 2, unit_price: 10.00 },
    { product: product2, quantity: 1, unit_price: 25.00 }
  ]
)
```

### Dependent Factories

```ruby
FactoryBot.define do
  factory :published_post, parent: :post do
    published { true }
    published_at { 1.day.ago }
    author { association :user, :confirmed }
  end

  factory :popular_post, parent: :published_post do
    views_count { 1000 }

    after(:create) do |post|
      create_list(:comment, 20, post: post, approved: true)
    end
  end
end

# Usage
post = create(:popular_post)
# Creates a confirmed user, published post with 1000 views and 20 comments
```

### Dynamic Attributes Based on Other Attributes

```ruby
FactoryBot.define do
  factory :order_item do
    quantity { rand(1..5) }
    unit_price { Faker::Commerce.price(range: 10.0..100.0) }

    # Calculate total based on quantity and unit_price
    total { quantity * unit_price }

    association :order
    association :product
  end
end
```

## 🎯 Challenge: Social Network Factories

Create factories for a social network with:

1. **User Factory**
   - Basic info (email, username, password)
   - Profile (avatar, bio, location, birthday)
   - Traits: :verified, :private_account, :with_followers
   - Transient: followers_count, following_count, posts_count

2. **Post Factory**
   - Content, image_url, video_url
   - Traits: :with_image, :with_video, :trending
   - Transient: likes_count, comments_count

3. **Friendship Factory**
   - Association: :user, :friend (also a user)
   - Status: 'pending', 'accepted', 'rejected'
   - Traits: :accepted, :pending

4. **Like Factory**
   - Association: :user, :likeable (polymorphic)
   - Support likes on posts and comments

5. **Notification Factory**
   - Type: 'like', 'comment', 'follow', 'mention'
   - Read/unread status
   - Association: :user, :notifiable (polymorphic)

Then write comprehensive tests using these factories!

## 🐍 Python Comparison

```python
# Python (factory_boy)
class UserFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = User

    email = factory.Sequence(lambda n: f'user{n}@example.com')
    first_name = factory.Faker('first_name')

    class Params:
        admin = factory.Trait(
            is_admin=True,
            is_confirmed=True
        )

# Usage
user = UserFactory()
admin = UserFactory(admin=True)
users = UserFactory.create_batch(5)
```

```ruby
# Ruby (FactoryBot)
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    first_name { Faker::Name.first_name }

    trait :admin do
      is_admin { true }
      is_confirmed { true }
    end
  end
end

# Usage
user = create(:user)
admin = create(:user, :admin)
users = create_list(:user, 5)
```

## ✅ Success Criteria

- [ ] Created user factory with 3+ traits
- [ ] Created post factory with associations
- [ ] Created comment factory with nested comments
- [ ] Used transient attributes
- [ ] Wrote tests using different build strategies
- [ ] Implemented e-commerce factories
- [ ] Comfortable with sequences and Faker

## 💡 Tips

1. **Use build over create** when you don't need database persistence
2. **Use build_stubbed** for maximum speed in unit tests
3. **Keep factories DRY** with traits
4. **Use Faker** for realistic data
5. **Don't create too much data** in tests - only what you need
6. **Use sequences** for unique values
7. **Test the factory** itself occasionally to ensure it's valid

---

**Pro tip:** Run `FactoryBot.lint` to validate all factories:

```ruby
# spec/support/factory_bot.rb
RSpec.configure do |config|
  config.before(:suite) do
    FactoryBot.lint
  end
end
```

This catches factory errors early! 🚀
