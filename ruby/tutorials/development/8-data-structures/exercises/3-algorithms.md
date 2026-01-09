# Exercise 3: Algorithm Implementation

Implement common algorithms in idiomatic Ruby.

## Challenge: String Algorithms

Implement various string manipulation algorithms.

```ruby
# 1. Longest common substring
def longest_common_substring(str1, str2)
  # TODO: Implement using dynamic programming
end

# 2. Valid palindrome
def valid_palindrome?(str)
  # TODO: Two pointer approach
end

# 3. Anagram groups
def group_anagrams(strings)
  # TODO: Group strings that are anagrams
end

# Test
longest_common_substring("abcdef", "abfdef")  # => "ab"
valid_palindrome?("A man, a plan, a canal: Panama")  # => true
group_anagrams(["eat", "tea", "tan", "ate", "nat", "bat"])
# => [["eat", "tea", "ate"], ["tan", "nat"], ["bat"]]
```

## Key Learning

Ruby's expressiveness makes algorithms readable and concise.
