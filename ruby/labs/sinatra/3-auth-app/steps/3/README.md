# Step 3: User Model with Validations

[← Previous Step](../2/README.md) | [Next Step →](../4/README.md)

**Estimated Time**: 25 minutes

## 🎯 Goal
Create User model with email and name validation.

## 📝 Tasks

### 1. Create User model (lib/models/user.rb)

```ruby
class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true, length: { minimum: 2, maximum: 50 }

  before_save :downcase_email

  private

  def downcase_email
    self.email = email.downcase if email
  end
end
```

### 2. Create users table (db/migrate.rb)

```ruby
require_relative '../config/database'

ActiveRecord::Base.connection.create_table :users, force: true do |t|
  t.string :email, null: false
  t.string :password_digest, null: false
  t.string :name, null: false
  t.timestamps
end

ActiveRecord::Base.connection.add_index :users, :email, unique: true

puts "✓ Users table created"
```

### 3. Run migration

```bash
ruby db/migrate.rb
```

### 4. Load model in app.rb

```ruby
require 'sinatra'
require_relative 'config/database'
require_relative 'lib/models/user'

# ... rest of code
```

## ✅ Checkpoint

Test the model in IRB:
```bash
irb -r ./app.rb
```

Then try:
```ruby
User.create(name: "Test", email: "test@example.com", password_digest: "temp")
User.count  # Should return 1
User.first.email  # Should return "test@example.com"
```

Verify:
- [ ] Users table exists in auth_app.db
- [ ] User model validates email format
- [ ] Email is automatically downcased
- [ ] Name length validation works (min 2, max 50)

## 💡 What You Learned

- Creating ActiveRecord models with validations
- Email validation using URI::MailTo::EMAIL_REGEXP
- Database migrations with ActiveRecord
- Using callbacks (before_save) for data normalization
- Adding indexes for performance and uniqueness constraints

## 🎯 Tips

- Always index email columns for fast lookups
- Downcase emails to prevent duplicate accounts (john@ex.com vs John@ex.com)
- Use presence and format validations together for robust email checking
- The password_digest column will be used in the next step with BCrypt

---

[← Previous Step](../2/README.md) | [Next Step →](../4/README.md)
