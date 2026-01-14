# Step 1: Basic API Setup

**Estimated Time:** 20 minutes

[Next Step →](../2/README.md)

---

## 🎯 Goal

Create a Sinatra API that returns JSON responses.

## 📝 Tasks

### 1. Create app.rb

```ruby
require 'sinatra'
require 'json'

# Set content type to JSON for all responses
before do
  content_type :json
end

# API root
get '/api/v1' do
  { message: 'Blog API v1', status: 'running' }.to_json
end

# Health check
get '/api/v1/health' do
  { status: 'ok', timestamp: Time.now }.to_json
end
```

### 2. Test the API

```bash
ruby app.rb
# Visit http://localhost:4567/api/v1
# Or use curl:
curl http://localhost:4567/api/v1
```

You should see a JSON response like:
```json
{"message":"Blog API v1","status":"running"}
```

## ✅ Checkpoint

Before moving to the next step, verify:

- [ ] API returns JSON
- [ ] Health endpoint works (`/api/v1/health`)
- [ ] Content-Type header is `application/json`
- [ ] No errors in the terminal

## 🎓 What You Learned

- Creating a JSON API with Sinatra
- Using the `before` filter to set content type
- Converting Ruby hashes to JSON with `.to_json`
- Creating health check endpoints

## 💡 Tips

- The `before` block runs before every request
- `.to_json` requires `require 'json'`
- Health checks are important for monitoring in production

---

[Next: Add Database →](../2/README.md)
