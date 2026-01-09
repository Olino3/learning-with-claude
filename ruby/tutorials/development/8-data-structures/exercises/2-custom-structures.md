# Exercise 2: Custom Data Structures

Implement classic data structures in Ruby.

## Challenge: LRU Cache

Implement a Least Recently Used cache with O(1) operations.

```ruby
class LRUCache
  def initialize(capacity)
    @capacity = capacity
    # TODO: Implement using hash + doubly linked list
  end

  def get(key)
    # TODO: Return value, mark as recently used
  end

  def put(key, value)
    # TODO: Add/update, evict LRU if needed
  end
end

# Usage
cache = LRUCache.new(2)
cache.put(1, 1)
cache.put(2, 2)
cache.get(1)       # => 1
cache.put(3, 3)    # Evicts key 2
cache.get(2)       # => nil
```

## Key Learning

Understand tradeoffs between different data structure implementations.
