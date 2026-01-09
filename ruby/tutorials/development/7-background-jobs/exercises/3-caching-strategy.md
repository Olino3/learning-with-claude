# Exercise 3: Multi-Level Caching

Implement a comprehensive caching strategy for an e-commerce site.

## Challenge: Cache Product Catalog

```ruby
class ProductsController < ApplicationController
  def index
    @categories = Category.includes(:products).all
    @featured = Product.featured.includes(:images)
  end

  def show
    @product = Product.includes(:reviews, :images).find(params[:id])
    @related = @product.related_products
  end
end
```

**Implement:**
1. Fragment caching for views
2. Russian Doll caching
3. Low-level caching for calculations
4. HTTP caching with ETags
5. Cache invalidation strategy

## Key Learning

Strategic caching at multiple levels provides the best performance improvement.
