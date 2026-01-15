# Step 3: User Model with Authentication

**Estimated Time:** 30 minutes

[← Previous Step](../2/README.md) | [Next Step →](../4/README.md)

---

## 🎯 Goal

Create User model with secure password hashing using BCrypt.

## 📝 Tasks

### 1. Install BCrypt

```bash
gem install bcrypt
```

### 2. Create User model (`lib/models/user.rb`)

```bash
mkdir -p lib/models
```

```ruby
require 'active_record'
require 'bcrypt'

class User < ActiveRecord::Base
  # Virtual attribute for password
  attr_accessor :password

  # Validations
  validates :email, presence: true, uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?

  # Hash password before saving
  before_save :hash_password, if: :password_present?

  # Authenticate user
  def authenticate(password)
    BCrypt::Password.new(password_digest) == password
  end

  # JSON representation (hide password_digest)
  def as_json(options = {})
    super(options.merge(except: [:password_digest]))
  end

  private

  def password_required?
    password_digest.blank?
  end

  def password_present?
    password.present?
  end

  def hash_password
    self.password_digest = BCrypt::Password.create(password)
  end
end
```

### 3. Create migration helper (`db/migrate.rb`)

```bash
mkdir -p db
```

```ruby
require_relative '../config/database'

# Load all models
Dir['./lib/models/*.rb'].each { |file| require file }

# Run migrations
ActiveRecord::Base.connection.create_table :users, force: true do |t|
  t.string :email, null: false
  t.string :password_digest, null: false
  t.string :name, null: false
  t.timestamps
end

ActiveRecord::Base.connection.add_index :users, :email, unique: true

puts "✓ Users table created"
```

### 4. Run the migration

```bash
ruby db/migrate.rb
```

### 5. Load models in app.rb

Update your `app.rb`:

```ruby
require 'sinatra'
require 'json'
require_relative 'config/database'
require_relative 'lib/models/user'

# ... rest of code
```

## ✅ Checkpoint

Before moving to the next step, verify:

- [ ] Users table exists in database
- [ ] User model validates correctly
- [ ] Password hashing works with BCrypt
- [ ] `as_json` excludes `password_digest`
- [ ] No errors when loading the app

## 🎓 What You Learned

- Using BCrypt for secure password hashing
- Creating virtual attributes in ActiveRecord
- Model validations (presence, uniqueness, format, length)
- Using callbacks (`before_save`) for automatic processing
- Customizing JSON serialization

## 🔒 Security Note

Never store passwords in plain text! BCrypt:
- Salts and hashes passwords
- Protects against rainbow table attacks
- Uses adaptive hashing (gets slower over time)

---

[← Previous: Add Database](../2/README.md) | [Next: JWT Authentication →](../4/README.md)
