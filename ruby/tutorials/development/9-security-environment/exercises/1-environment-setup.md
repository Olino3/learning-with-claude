# Exercise 1: Secure Environment Configuration

Set up a complete, secure environment management system.

## Challenge: Multi-Environment Configuration

Create a secure configuration system for development, test, staging, and production.

**Requirements:**
1. Use dotenv for development
2. Rails credentials for production secrets
3. Environment-specific database configs
4. API keys for external services
5. Secure master key management

```ruby
# .env.development
DATABASE_URL=postgresql://localhost/myapp_dev
REDIS_URL=redis://localhost:6379
STRIPE_API_KEY=sk_test_xxx
AWS_ACCESS_KEY=dev_key

# config/credentials.yml.enc (encrypted)
production:
  database:
    password: secure_prod_password
  stripe:
    api_key: sk_live_xxx
  aws:
    access_key_id: AKIA...
    secret_access_key: xxx
```

## Key Learning

Never commit secrets. Use encrypted credentials for production.
