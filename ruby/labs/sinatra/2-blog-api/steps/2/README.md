# Step 2: Add Database with ActiveRecord

**Estimated Time:** 25 minutes

[← Previous Step](../1/README.md) | [Next Step →](../3/README.md)

---

## 🎯 Goal

Set up PostgreSQL with ActiveRecord ORM.

## 📝 Tasks

### 1. Install gems

```bash
gem install sinatra activerecord pg
```

### 2. Create database configuration (`config/database.rb`)

```bash
mkdir -p config
```

```ruby
require 'active_record'

# Database connection
db_config = {
  adapter: 'postgresql',
  host: ENV['DB_HOST'] || 'localhost',
  database: ENV['DB_NAME'] || 'blog_api_dev',
  username: ENV['DB_USER'] || 'postgres',
  password: ENV['DB_PASSWORD'] || '',
  pool: 5,
  timeout: 5000
}

# For development, you can use SQLite instead:
# db_config = {
#   adapter: 'sqlite3',
#   database: 'blog_api.db'
# }

ActiveRecord::Base.establish_connection(db_config)

# Enable logging in development
ActiveRecord::Base.logger = Logger.new(STDOUT) if development?
```

### 3. Update app.rb

```ruby
require 'sinatra'
require 'json'
require_relative 'config/database'

before do
  content_type :json
end

get '/api/v1' do
  {
    message: 'Blog API v1',
    status: 'running',
    database: 'connected'
  }.to_json
end

get '/api/v1/health' do
  {
    status: 'ok',
    timestamp: Time.now,
    database: ActiveRecord::Base.connected? ? 'connected' : 'disconnected'
  }.to_json
end
```

### 4. Create the database

```bash
# PostgreSQL
createdb blog_api_dev

# Or if using Docker
docker-compose exec postgres createdb -U postgres blog_api_dev
```

## ✅ Checkpoint

Before moving to the next step, verify:

- [ ] Database connection works
- [ ] Health endpoint shows database status as "connected"
- [ ] No connection errors in terminal
- [ ] ActiveRecord logging appears (SQL queries)

## 🎓 What You Learned

- Configuring ActiveRecord outside of Rails
- Setting up PostgreSQL connections
- Using environment variables for database config
- Checking database connectivity programmatically

## 🔍 Database Configuration

```ruby
# Key settings:
adapter:  'postgresql'  # Database type
host:     'localhost'   # Where database runs
database: 'blog_api_dev'  # Database name
pool:     5             # Connection pool size
```

## 💡 Tips

- Use SQLite for simpler local development
- Keep database credentials in environment variables
- Connection pool prevents resource exhaustion
- Enable SQL logging in development for debugging

---

[← Previous: Basic API Setup](../1/README.md) | [Next: User Model →](../3/README.md)
