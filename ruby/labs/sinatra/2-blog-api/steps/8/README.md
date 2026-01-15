# Step 8: Pagination

**Estimated Time:** 15 minutes

[← Previous Step](../7/README.md) | [Next Step →](../9/README.md)

---

## 🎯 Goal

Add pagination to efficiently handle large datasets.

## 📝 Tasks

### 1. Create pagination helper (`lib/pagination.rb`)

```ruby
module Sinatra
  module PaginationHelper
    def paginate(collection, page: 1, per_page: 10)
      page = [page.to_i, 1].max
      per_page = [[per_page.to_i, 1].max, 100].min

      total = collection.count
      items = collection.limit(per_page).offset((page - 1) * per_page)

      {
        items: items,
        metadata: {
          current_page: page,
          per_page: per_page,
          total_items: total,
          total_pages: (total.to_f / per_page).ceil
        }
      }
    end
  end

  helpers PaginationHelper
end
```

### 2. Load helper in app.rb

```ruby
require_relative 'lib/pagination'
```

### 3. Update posts route to use pagination

Replace the `GET /api/v1/posts` route:

```ruby
get '/api/v1/posts' do
  page = params[:page] || 1
  per_page = params[:per_page] || 10

  result = paginate(
    Post.includes(:user, :tags).recent,
    page: page,
    per_page: per_page
  )

  {
    posts: result[:items].map(&:as_json),
    pagination: result[:metadata]
  }.to_json
end
```

### 4. Test pagination

```bash
# Get first page (default 10 items per page)
curl http://localhost:4567/api/v1/posts

# Get page 2
curl http://localhost:4567/api/v1/posts?page=2

# Get 5 items per page
curl http://localhost:4567/api/v1/posts?per_page=5

# Get page 2 with 5 items per page
curl http://localhost:4567/api/v1/posts?page=2&per_page=5
```

Expected response format:
```json
{
  "posts": [...],
  "pagination": {
    "current_page": 1,
    "per_page": 10,
    "total_items": 25,
    "total_pages": 3
  }
}
```

## ✅ Checkpoint

Before moving to the next step, verify:

- [ ] Posts are paginated
- [ ] Can specify page number
- [ ] Can specify items per page
- [ ] Pagination metadata is included
- [ ] Maximum per_page is capped at 100
- [ ] Minimum page is 1

## 🎓 What You Learned

- Implementing pagination with `limit` and `offset`
- Adding metadata for client-side pagination controls
- Protecting against invalid pagination parameters
- Optimizing database queries for large datasets
- Returning structured JSON with data and metadata

## 🔍 Pagination Math

```ruby
offset = (page - 1) * per_page
limit = per_page

# Page 1, 10 per page: offset 0, limit 10
# Page 2, 10 per page: offset 10, limit 10
# Page 3, 10 per page: offset 20, limit 10
```

## 💡 Tips

- Always cap `per_page` to prevent abuse (e.g., 100 max)
- Default to reasonable values (page=1, per_page=10)
- Include total counts for UI pagination controls
- Consider cursor-based pagination for infinite scroll
- Cache counts for better performance

---

[← Previous: Tagging System](../7/README.md) | [Next: Error Handling →](../9/README.md)
