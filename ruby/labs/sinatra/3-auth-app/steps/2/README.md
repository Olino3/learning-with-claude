# Step 2: Add Database

[← Previous Step](../1/README.md) | [Next Step →](../3/README.md)

**Estimated Time**: 20 minutes

## 🎯 Goal
Set up SQLite database with ActiveRecord.

## 📝 Tasks

### 1. Install gems

```bash
gem install activerecord sqlite3
```

### 2. Create database config (config/database.rb)

```ruby
require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'auth_app.db'
)
```

### 3. Update app.rb

Add the database configuration at the top:

```ruby
require 'sinatra'
require_relative 'config/database'

enable :sessions
set :session_secret, ENV.fetch('SESSION_SECRET', 'change_this_in_production')

# ... rest of code
```

## ✅ Checkpoint

Run the lab:
```bash
make sinatra-lab NUM=3
```

Test that:
- [ ] Database connection works without errors
- [ ] auth_app.db file is created in the project root
- [ ] Application still runs and displays the home page

## 💡 What You Learned

- Setting up ActiveRecord with SQLite
- Database configuration for Sinatra applications
- Using relative paths to organize configuration files
- How ActiveRecord establishes database connections

## 🎯 Tips

- SQLite is perfect for development but consider PostgreSQL for production
- The database file (auth_app.db) is created automatically when first accessed
- ActiveRecord handles connection pooling automatically
- Keep database credentials in environment variables for production

---

[← Previous Step](../1/README.md) | [Next Step →](../3/README.md)
