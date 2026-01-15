# Exercise 2: Type-Safe Cache System

Build a generic caching system that stores values by key with expiration support.

## 📝 Requirements

Create a `Cache<K, V>` class with the following features:

1. `void set(K key, V value, {Duration? ttl})` - Store a value with optional time-to-live
2. `V? get(K key)` - Retrieve a value (null if expired or not found)
3. `void delete(K key)` - Remove a cached value
4. `void clear()` - Remove all cached values
5. `bool containsKey(K key)` - Check if a non-expired key exists
6. `int get size` - Get the number of cached items

## 🎯 Example Usage

```dart
void main() {
  var cache = Cache<String, int>();
  
  // Store without expiration
  cache.set('age', 30);
  print(cache.get('age'));  // 30
  
  // Store with TTL
  cache.set('temp', 100, ttl: Duration(seconds: 2));
  print(cache.get('temp'));  // 100
  
  // Wait for expiration
  await Future.delayed(Duration(seconds: 3));
  print(cache.get('temp'));  // null (expired)
  
  // User object cache
  var userCache = Cache<int, User>();
  userCache.set(1, User('Alice'));
  print(userCache.get(1)?.name);  // Alice
}
```

## 💡 Hints

- Use a `Map<K, CacheEntry<V>>` internally
- Create a `CacheEntry<V>` class to store value and expiration time
- Check expiration in the `get` method
- Use `DateTime.now()` for expiration checks

## ✅ Solution

<details>
<summary>Click to reveal solution</summary>

```dart
class CacheEntry<V> {
  final V value;
  final DateTime? expiresAt;
  
  CacheEntry(this.value, {this.expiresAt});
  
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }
}

class Cache<K, V> {
  final Map<K, CacheEntry<V>> _storage = {};
  
  void set(K key, V value, {Duration? ttl}) {
    final expiresAt = ttl != null 
        ? DateTime.now().add(ttl) 
        : null;
    
    _storage[key] = CacheEntry(value, expiresAt: expiresAt);
  }
  
  V? get(K key) {
    final entry = _storage[key];
    
    if (entry == null) return null;
    
    if (entry.isExpired) {
      _storage.remove(key);
      return null;
    }
    
    return entry.value;
  }
  
  void delete(K key) {
    _storage.remove(key);
  }
  
  void clear() {
    _storage.clear();
  }
  
  bool containsKey(K key) {
    return get(key) != null;
  }
  
  int get size {
    // Clean up expired entries first
    _storage.removeWhere((key, entry) => entry.isExpired);
    return _storage.length;
  }
}

class User {
  final String name;
  User(this.name);
}

void main() async {
  var cache = Cache<String, int>();
  
  cache.set('age', 30);
  cache.set('temp', 100, ttl: Duration(seconds: 2));
  
  print(cache.get('age'));   // 30
  print(cache.get('temp'));  // 100
  print(cache.size);         // 2
  
  await Future.delayed(Duration(seconds: 3));
  
  print(cache.get('temp'));  // null (expired)
  print(cache.size);         // 1
  
  cache.clear();
  print(cache.size);         // 0
}
```

</details>

## 🚀 Bonus Challenges

1. Add a `getOrSet(K key, V Function() factory, {Duration? ttl})` method
2. Implement automatic cleanup of expired entries using a periodic timer
3. Add a maximum cache size with LRU (Least Recently Used) eviction
4. Track cache hits and misses for statistics
