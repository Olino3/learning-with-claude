#!/usr/bin/env ruby
# Error Handling Practice

puts "=== Error Handling ==="
puts

begin
  result = 10 / 0
rescue ZeroDivisionError => e
  puts "Caught error: #{e.message}"
end

def risky_operation
  raise StandardError, "Something went wrong"
rescue => e
  puts "Rescued: #{e.message}"
ensure
  puts "Cleanup always runs"
end

risky_operation

puts "\n=== Practice Complete ==="
