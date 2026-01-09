# Exercise 3: Secure Authentication System

Build a production-ready authentication system with security best practices.

## Requirements

1. User registration with email verification
2. Secure password requirements (12+ chars, complexity)
3. Password reset with expiring tokens
4. Account lockout after failed attempts
5. Session timeout
6. Remember me functionality
7. Two-factor authentication (bonus)

```ruby
class User < ApplicationRecord
  has_secure_password

  # TODO: Add validations
  # TODO: Add email verification
  # TODO: Add password reset
  # TODO: Add account lockout
  # TODO: Add 2FA
end
```

## Security Checklist

- [ ] Passwords hashed with bcrypt
- [ ] Password complexity enforced
- [ ] Email verification required
- [ ] Password reset tokens expire
- [ ] Account locks after 5 failed attempts
- [ ] Sessions expire after inactivity
- [ ] HTTPS only (force_ssl)
- [ ] CSRF protection enabled
- [ ] Secure session cookies

## Key Learning

Authentication requires multiple layers of security working together.
