# Exercise 2: Decorators and Query Objects

Practice building decorators for presentation logic and query objects for complex database queries.

## Part 1: User Decorator

Build a decorator that adds social media and formatting logic.

```ruby
# app/decorators/user_decorator.rb
class UserDecorator < Draper::Decorator
  delegate_all

  def social_links
    # TODO: Return HTML with social media links
  end

  def avatar_tag
    # TODO: Return image tag with avatar
  end

  def member_since
    # TODO: Format created_at nicely
  end
end
```

<details>
<summary>Solution</summary>

```ruby
class UserDecorator < Draper::Decorator
  delegate_all

  def display_name
    "#{object.first_name} #{object.last_name}"
  end

  def social_links
    links = []
    links << twitter_link if object.twitter_handle.present?
    links << github_link if object.github_username.present?
    links << linkedin_link if object.linkedin_url.present?

    h.safe_join(links, ' ')
  end

  def avatar_tag(size: 50)
    h.image_tag avatar_url, alt: display_name, size: size, class: 'avatar'
  end

  def member_since
    h.content_tag :span, "Member since #{object.created_at.strftime('%B %Y')}",
                  class: 'text-muted'
  end

  private

  def avatar_url
    object.avatar.present? ? object.avatar.url : h.image_path('default-avatar.png')
  end

  def twitter_link
    h.link_to h.icon('twitter'), "https://twitter.com/#{object.twitter_handle}",
              target: '_blank', rel: 'noopener'
  end

  def github_link
    h.link_to h.icon('github'), "https://github.com/#{object.github_username}",
              target: '_blank', rel: 'noopener'
  end

  def linkedin_link
    h.link_to h.icon('linkedin'), object.linkedin_url,
              target: '_blank', rel: 'noopener'
  end
end
```
</details>

## Part 2: Product Search Query

Build a query object for advanced product search.

<details>
<summary>Solution</summary>

```ruby
# app/queries/products/advanced_search_query.rb
module Products
  class AdvancedSearchQuery
    def initialize(relation = Product.all)
      @relation = relation
    end

    def call(filters = {})
      @relation
        .then { |r| by_category(r, filters[:category_ids]) }
        .then { |r| by_price_range(r, filters[:min_price], filters[:max_price]) }
        .then { |r| by_rating(r, filters[:min_rating]) }
        .then { |r| in_stock(r, filters[:in_stock_only]) }
        .then { |r| search_text(r, filters[:query]) }
        .then { |r| with_discount(r, filters[:on_sale]) }
        .then { |r| sort_results(r, filters[:sort]) }
    end

    private

    def by_category(relation, category_ids)
      return relation unless category_ids.present?

      relation.where(category_id: category_ids)
    end

    def by_price_range(relation, min_price, max_price)
      relation = relation.where('price >= ?', min_price) if min_price.present?
      relation = relation.where('price <= ?', max_price) if max_price.present?
      relation
    end

    def by_rating(relation, min_rating)
      return relation unless min_rating.present?

      relation.where('average_rating >= ?', min_rating)
    end

    def in_stock(relation, in_stock_only)
      return relation unless in_stock_only == '1'

      relation.where('stock > 0')
    end

    def search_text(relation, query)
      return relation unless query.present?

      relation.where(
        'name ILIKE :q OR description ILIKE :q OR sku ILIKE :q',
        q: "%#{query}%"
      )
    end

    def with_discount(relation, on_sale)
      return relation unless on_sale == '1'

      relation.where('discount_percent > 0')
    end

    def sort_results(relation, sort_option)
      case sort_option
      when 'price_asc' then relation.order(price: :asc)
      when 'price_desc' then relation.order(price: :desc)
      when 'name' then relation.order(name: :asc)
      when 'rating' then relation.order(average_rating: :desc)
      when 'newest' then relation.order(created_at: :desc)
      else relation.order(id: :desc)
      end
    end
  end
end
```
</details>

## Key Learnings

- Decorators keep views clean
- Query objects make complex queries maintainable
- Chain methods with `then` for readability
- Test query objects with realistic filters

## Next Steps

Continue to **[Exercise 3: Forms & Policies](3-forms-policies.md)**!
