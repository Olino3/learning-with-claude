# Exercise 2: Debugging with Pry

Practice using Pry to debug complex issues.

## Challenge: Debug N+1 Query

```ruby
class PostsController < ApplicationController
  def index
    @posts = Post.all
  end
end

# View triggers N+1
<% @posts.each do |post| %>
  <%= post.title %>
  <%= post.author.name %>  # N+1!
  <%= post.comments.count %>  # N+1!
<% end %>
```

**Tasks:**
1. Add `binding.pry` to identify N+1
2. Use `ls`, `cd` to explore ActiveRecord
3. Fix with eager loading
4. Verify with Pry

## Pry Commands

```ruby
[1] pry> @posts.first
[2] pry> cd @posts.first
[3] pry> ls -m | grep author
[4] pry> show-source author
```

## Key Learning

Pry's introspection features help identify and fix performance issues.
