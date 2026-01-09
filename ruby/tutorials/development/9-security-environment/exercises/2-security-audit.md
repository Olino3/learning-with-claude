# Exercise 2: Security Vulnerability Audit

Find and fix security vulnerabilities in a Rails application.

## Challenge: Vulnerable Application

Audit this code for security issues:

```ruby
class UsersController < ApplicationController
  def index
    @users = User.where("name LIKE '%#{params[:query]}%'")
  end

  def show
    @user = User.find(params[:id])
    @profile = @user.profile
  end

  def update
    @user = User.find(params[:id])
    @user.update(params[:user])
  end
end

# View
<div><%= raw @user.bio %></div>
<script>
  var userId = <%= @user.id %>;
</script>
```

**Find and fix:**
1. SQL injection
2. XSS vulnerability
3. Mass assignment
4. Insecure direct object reference
5. Missing authentication

## Key Learning

Always sanitize input, use parameterized queries, and implement proper authorization.
