# Exercise: Object-Oriented Programming

## Practice

```ruby
class BankAccount
  attr_reader :balance
  attr_accessor :owner

  def initialize(owner, initial_balance = 0)
    @owner = owner
    @balance = initial_balance
  end

  def deposit(amount)
    @balance += amount if amount > 0
  end

  def withdraw(amount)
    @balance -= amount if amount > 0 && amount <= @balance
  end
end

account = BankAccount.new("Alice", 100)
account.deposit(50)
account.withdraw(30)
puts account.balance
```

Run:
```bash
make run-script SCRIPT=ruby/tutorials/6-Object-Oriented-Programming/exercises/oop_practice.rb
```

## 🎉 Tutorial 6 Complete!
