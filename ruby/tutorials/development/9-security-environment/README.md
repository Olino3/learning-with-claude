# Tutorial 9: Security & Environment Management

Master security best practices and environment management in Ruby applications. This tutorial covers environment variables, secrets management, common vulnerabilities (XSS, SQL injection, CSRF), and secure authentication patterns.

## 📋 Learning Objectives

By the end of this tutorial, you will:
- Manage environment variables with dotenv
- Handle secrets securely
- Prevent XSS, SQL injection, and CSRF attacks
- Implement secure authentication
- Use Rails credentials and encryption
- Follow security best practices
- Compare Ruby security to Python approaches
- Audit dependencies for vulnerabilities

## 🐍➡️🔴 Coming from Python

If you're familiar with Python security tools, here's how Ruby compares:

| Concept | Python | Ruby | Key Difference |
|---------|--------|------|----------------|
| Env variables | python-dotenv | dotenv | Similar functionality |
| Secrets | environment, vault | Rails credentials, ENV | Rails has built-in encryption |
| Env management | python-decouple | dotenv, figaro | dotenv simpler |
| XSS prevention | Django auto-escaping | Rails auto-escaping | Both safe by default |
| SQL injection | Django ORM | ActiveRecord | Both parameterize queries |
| CSRF protection | Django middleware | Rails built-in | Both included by default |
| Password hashing | bcrypt, Argon2 | bcrypt | Same library |
| Auth framework | Django auth | Devise, Sorcery | Ruby has gems |
| Audit tools | safety | bundler-audit | Similar purpose |

> **📘 Python Note:** Rails includes more security features by default than Django, but both frameworks are secure when used correctly.

## 📝 Part 1: Environment Variables with Dotenv

### Installing Dotenv

```ruby
# Gemfile
gem 'dotenv-rails', groups: [:development, :test]

bundle install
```

### Using .env Files

```bash
# .env - Development environment
DATABASE_URL=postgresql://localhost/myapp_dev
REDIS_URL=redis://localhost:6379
API_KEY=your_development_api_key
SECRET_KEY_BASE=generate_with_rails_secret

# .env.test - Test environment
DATABASE_URL=postgresql://localhost/myapp_test
REDIS_URL=redis://localhost:6379/1

# .env.local - Local overrides (gitignored)
API_KEY=your_personal_api_key

# .env.production - Production (encrypted or in actual ENV)
# Don't commit this! Use actual environment variables
```

### Accessing Environment Variables

```ruby
# config/database.yml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS", 5) %>
  url: <%= ENV['DATABASE_URL'] %>

development:
  <<: *default

test:
  <<: *default

production:
  <<: *default

# In application code
api_key = ENV['API_KEY']
api_key = ENV.fetch('API_KEY')  # Raises if missing (safer)
api_key = ENV.fetch('API_KEY', 'default_value')  # With default

# With type casting
max_connections = ENV.fetch('MAX_CONNECTIONS', '10').to_i
debug_mode = ENV['DEBUG'] == 'true'
timeout = ENV.fetch('TIMEOUT', '30').to_f
```

### .gitignore Setup

```bash
# .gitignore
.env
.env.local
.env*.local
config/master.key
config/credentials/*.key
```

> **📘 Python Note:** Very similar to python-dotenv:
> ```python
> from dotenv import load_dotenv
> import os
>
> load_dotenv()
> api_key = os.getenv('API_KEY')
> ```

## 📝 Part 2: Rails Credentials and Secrets

### Rails Encrypted Credentials

```bash
# Edit credentials (Rails 6+)
EDITOR=vim rails credentials:edit

# This opens encrypted file for editing
# Decrypted content:
```

```yaml
# config/credentials.yml.enc (encrypted)
aws:
  access_key_id: AKIAIOSFODNN7EXAMPLE
  secret_access_key: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

stripe:
  publishable_key: pk_test_abc123
  secret_key: sk_test_xyz789

secret_key_base: very_long_random_string_for_sessions

database:
  password: secure_database_password
```

### Accessing Credentials

```ruby
# In application code
Rails.application.credentials.aws[:access_key_id]
Rails.application.credentials.stripe[:secret_key]
Rails.application.credentials.secret_key_base

# With dig for safe access
Rails.application.credentials.dig(:aws, :access_key_id)

# Environment-specific credentials (Rails 6+)
# config/credentials/production.yml.enc
Rails.application.credentials.database[:password]
```

### Environment-Specific Credentials

```bash
# Edit production credentials
rails credentials:edit --environment production

# Edit staging credentials
rails credentials:edit --environment staging

# Structure:
# config/credentials/production.yml.enc
# config/credentials/production.key
```

### Using Figaro (Alternative)

```ruby
# Gemfile
gem 'figaro'

# Setup
bundle exec figaro install

# config/application.yml (gitignored)
development:
  API_KEY: dev_key_123

test:
  API_KEY: test_key_456

production:
  API_KEY: prod_key_789

# Access
ENV['API_KEY']
Figaro.env.api_key
```

## 📝 Part 3: Common Security Vulnerabilities

### XSS (Cross-Site Scripting) Prevention

```ruby
# Rails auto-escapes HTML by default
# View (ERB)
<%= user.name %>  # Auto-escaped, safe

<%= sanitize user.bio %>  # Allows safe HTML tags

<%= raw user.html_content %>  # DANGEROUS! Only if you trust the source
<%= user.html_content.html_safe %>  # Same as raw

# Sanitize with whitelist
<%= sanitize user.comment, tags: %w[p br strong em], attributes: %w[href] %>

# Strip all tags
<%= strip_tags(user.input) %>

# JavaScript escaping
<script>
  var userName = "<%= j user.name %>";  # JavaScript-escaped
  // or
  var userName = <%= user.name.to_json %>;
</script>
```

### SQL Injection Prevention

```ruby
# ALWAYS use parameterized queries

# Bad: SQL injection vulnerable
user_input = params[:name]
User.where("name = '#{user_input}'")  # DANGEROUS!
# Attack: params[:name] = "' OR '1'='1"

# Good: Parameterized (safe)
User.where("name = ?", user_input)
User.where(name: user_input)

# Multiple parameters
User.where("name = ? AND age > ?", name, age)

# Named parameters
User.where("name = :name AND age > :age", name: name, age: age)

# Array conditions
User.where(name: ['Alice', 'Bob', 'Charlie'])

# Hash conditions
User.where(name: 'Alice', active: true)

# Dangerous: raw SQL
User.where("created_at > NOW() - INTERVAL '1 day'")  # OK - no user input

# Safe even with user input
User.where("created_at > ?", 1.day.ago)
```

### CSRF (Cross-Site Request Forgery) Protection

```ruby
# Enabled by default in Rails
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # or
  protect_from_forgery with: :null_session  # For APIs
end

# In views, form helpers include CSRF token automatically
<%= form_with model: @user do |f| %>
  <%= f.text_field :name %>
  <%= f.submit %>
<% end %>

# For AJAX requests
// In application.html.erb
<meta name="csrf-token" content="<%= form_authenticity_token %>">

// In JavaScript
const token = document.querySelector('[name="csrf-token"]').content;

fetch('/api/users', {
  method: 'POST',
  headers: {
    'X-CSRF-Token': token,
    'Content-Type': 'application/json'
  },
  body: JSON.stringify(data)
});

// Rails UJS handles this automatically
```

### Mass Assignment Protection

```ruby
# Strong parameters (Rails 4+)
class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    @user.save
  end

  private

  def user_params
    # Only allow specific attributes
    params.require(:user).permit(:name, :email, :password)
  end
end

# Nested attributes
def user_params
  params.require(:user).permit(
    :name,
    :email,
    profile_attributes: [:bio, :avatar],
    addresses_attributes: [:street, :city, :state]
  )
end

# Conditional permission
def user_params
  if current_user.admin?
    params.require(:user).permit(:name, :email, :role)
  else
    params.require(:user).permit(:name, :email)
  end
end
```

### Insecure Direct Object References

```ruby
# Bad: Exposing internal IDs
class PostsController < ApplicationController
  def show
    @post = Post.find(params[:id])  # Any ID can be accessed!
  end
end

# Good: Scope to current user
class PostsController < ApplicationController
  def show
    @post = current_user.posts.find(params[:id])
  end
end

# Or use UUIDs instead of incrementing IDs
class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts, id: :uuid do |t|
      t.string :title
      t.timestamps
    end
  end
end

# app/models/post.rb
class Post < ApplicationRecord
  self.primary_key = :id
end
```

## 📝 Part 4: Secure Authentication

### Using Devise

```ruby
# Gemfile
gem 'devise'

# Install
rails generate devise:install
rails generate devise User
rails db:migrate

# app/models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :trackable

  # Strong password requirements
  validates :password,
    length: { minimum: 12 },
    format: {
      with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])/,
      message: 'must include uppercase, lowercase, number, and special character'
    }
end

# Controller protection
class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = current_user.posts
  end
end
```

### Password Security

```ruby
# Use bcrypt (built into Rails)
# app/models/user.rb
class User < ApplicationRecord
  has_secure_password

  validates :password,
    length: { minimum: 12 },
    presence: true,
    on: :create
end

# Usage
user = User.create(
  email: 'user@example.com',
  password: 'SecureP@ssw0rd123',
  password_confirmation: 'SecureP@ssw0rd123'
)

user.authenticate('wrong_password')  # => false
user.authenticate('SecureP@ssw0rd123')  # => user

# Custom password strength validation
class User < ApplicationRecord
  validate :password_strength

  private

  def password_strength
    return if password.blank?

    unless password.match?(/\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])/)
      errors.add :password, 'must include uppercase, lowercase, number, and special character'
    end

    if CommonPasswordList.include?(password.downcase)
      errors.add :password, 'is too common'
    end
  end
end
```

### Session Security

```ruby
# config/initializers/session_store.rb
Rails.application.config.session_store :cookie_store,
  key: '_myapp_session',
  secure: Rails.env.production?,  # HTTPS only in production
  httponly: true,  # Not accessible via JavaScript
  same_site: :lax  # CSRF protection

# Expire sessions
class ApplicationController < ActionController::Base
  before_action :check_session_expiry

  private

  def check_session_expiry
    if session[:expires_at] && session[:expires_at] < Time.current
      reset_session
      redirect_to login_path, alert: 'Session expired'
    else
      session[:expires_at] = 30.minutes.from_now
    end
  end
end
```

### API Token Authentication

```ruby
# app/models/user.rb
class User < ApplicationRecord
  has_secure_password
  has_secure_token :auth_token

  def regenerate_auth_token
    update(auth_token: SecureRandom.hex(32))
  end
end

# app/controllers/api/base_controller.rb
module Api
  class BaseController < ActionController::API
    before_action :authenticate_token

    private

    def authenticate_token
      token = request.headers['Authorization']&.split(' ')&.last
      @current_user = User.find_by(auth_token: token)

      render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
    end
  end
end
```

## 📝 Part 5: Security Auditing

### Bundler Audit

```ruby
# Gemfile
group :development do
  gem 'bundler-audit'
end

# Run audit
bundle audit check --update

# CI integration
# .github/workflows/security.yml
name: Security Audit

on: [push, pull_request]

jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: 3.2
          bundler-cache: true
      - name: Security audit
        run: |
          gem install bundler-audit
          bundle audit check --update
```

### Brakeman (Rails Security Scanner)

```ruby
# Gemfile
group :development do
  gem 'brakeman'
end

# Run scan
brakeman

# Generate report
brakeman -o brakeman_report.html

# CI integration
- name: Brakeman scan
  run: |
    gem install brakeman
    brakeman --no-pager
```

### Security Headers

```ruby
# config/application.rb
config.force_ssl = true  # Redirect HTTP to HTTPS

# config/initializers/security_headers.rb
Rails.application.config.action_dispatch.default_headers = {
  'X-Frame-Options' => 'SAMEORIGIN',
  'X-Content-Type-Options' => 'nosniff',
  'X-XSS-Protection' => '1; mode=block',
  'Referrer-Policy' => 'strict-origin-when-cross-origin',
  'Content-Security-Policy' => "default-src 'self'; script-src 'self' 'unsafe-inline';"
}

# Using secure_headers gem
gem 'secure_headers'

# config/initializers/secure_headers.rb
SecureHeaders::Configuration.default do |config|
  config.x_frame_options = 'SAMEORIGIN'
  config.x_content_type_options = 'nosniff'
  config.x_xss_protection = '1; mode=block'
  config.referrer_policy = 'strict-origin-when-cross-origin'

  config.csp = {
    default_src: %w['self'],
    script_src: %w['self' 'unsafe-inline'],
    style_src: %w['self' 'unsafe-inline'],
    img_src: %w['self' data: https:],
    font_src: %w['self' data:],
    connect_src: %w['self'],
    frame_ancestors: %w['none']
  }
end
```

## ✍️ Exercises

### Exercise 1: Environment Setup
👉 **[Secure Configuration](exercises/1-environment-setup.md)**

Set up:
- Dotenv for local development
- Rails credentials for production
- Environment-specific configs
- Secret rotation strategy

### Exercise 2: Security Audit
👉 **[Find Vulnerabilities](exercises/2-security-audit.md)**

Audit and fix:
- SQL injection vulnerabilities
- XSS vulnerabilities
- CSRF issues
- Dependency vulnerabilities

### Exercise 3: Secure Authentication
👉 **[Build Auth System](exercises/3-secure-authentication.md)**

Implement:
- User registration with email verification
- Secure password reset
- Two-factor authentication
- Session management

## 📚 What You Learned

✅ Environment variable management
✅ Rails credentials and encryption
✅ XSS, SQL injection, CSRF prevention
✅ Secure authentication patterns
✅ Mass assignment protection
✅ Security auditing tools
✅ Security headers and policies
✅ Best practices for production

## 💡 Key Takeaways for Python Developers

1. **dotenv**: Same in both languages
2. **Rails credentials**: More sophisticated than Django
3. **Auto-escaping**: Both Rails and Django safe by default
4. **ORM protection**: Both prevent SQL injection
5. **CSRF**: Built into both frameworks
6. **Password hashing**: Use bcrypt in both
7. **Auditing**: bundler-audit ≈ safety
8. **Security**: Similar principles, different tools

## 🆘 Common Pitfalls

### Pitfall 1: Committing Secrets

```bash
# Bad
git add .env
git commit -m "Add config"

# Good
# .gitignore
.env
.env.local
config/master.key
```

### Pitfall 2: Weak Passwords

```ruby
# Bad
validates :password, length: { minimum: 6 }

# Good
validates :password,
  length: { minimum: 12 },
  format: { with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/ }
```

### Pitfall 3: Trusting User Input

```ruby
# Bad
User.where("email = '#{params[:email]}'")
content.html_safe

# Good
User.where(email: params[:email])
sanitize(content)
```

## 📖 Additional Resources

- [Rails Security Guide](https://guides.rubyonrails.org/security.html)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Rails Security Checklist](https://github.com/eliotsykes/rails-security-checklist)
- [Brakeman Documentation](https://brakemanscanner.org/docs/)
- [Devise Documentation](https://github.com/heartcombo/devise)

---

Congratulations! You've completed all Ruby Development tutorials! 🎉

Continue to **[Exercise 1: Environment Setup](exercises/1-environment-setup.md)** to practice what you learned!
