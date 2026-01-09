# Exercise 2: Query Optimization

Use Bullet to detect and fix N+1 queries in a blog application.

## Challenge: Optimize Blog Listing

```ruby
# app/controllers/posts_controller.rb
def index
  @posts = Post.all
end

# app/views/posts/index.html.erb
<% @posts.each do |post| %>
  <h2><%= post.title %></h2>
  <p>By <%= post.author.name %></p>
  <p><%= post.comments.count %> comments</p>
  <p>Tags: <%= post.tags.map(&:name).join(', ') %></p>
<% end %>
```

**Tasks:**
1. Enable Bullet
2. Identify all N+1 queries
3. Fix with includes/preload
4. Verify with Bullet
5. Benchmark improvements

## Key Learning

Eager loading eliminates N+1 queries and dramatically improves performance.
