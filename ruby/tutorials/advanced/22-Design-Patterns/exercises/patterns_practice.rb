#!/usr/bin/env ruby
# Design Patterns Practice

require 'delegate'
require 'singleton'
require 'observer'

puts "=" * 70
puts "DESIGN PATTERNS PRACTICE"
puts "=" * 70
puts

# Example 1: Decorator Pattern with SimpleDelegator
puts "1. Decorator Pattern with SimpleDelegator"
puts "-" * 70

class Coffee
  def cost
    2.00
  end
  
  def description
    "Coffee"
  end
end

class MilkDecorator < SimpleDelegator
  def cost
    __getobj__.cost + 0.50
  end
  
  def description
    "#{__getobj__.description} with Milk"
  end
end

class SugarDecorator < SimpleDelegator
  def cost
    __getobj__.cost + 0.25
  end
  
  def description
    "#{__getobj__.description} with Sugar"
  end
end

coffee = Coffee.new
puts "#{coffee.description}: $#{coffee.cost}"

coffee_with_milk = MilkDecorator.new(coffee)
puts "#{coffee_with_milk.description}: $#{coffee_with_milk.cost}"

coffee_with_milk_and_sugar = SugarDecorator.new(coffee_with_milk)
puts "#{coffee_with_milk_and_sugar.description}: $#{coffee_with_milk_and_sugar.cost}"

puts

# Example 2: Singleton Pattern
puts "2. Singleton Pattern"
puts "-" * 70

class AppConfig
  include Singleton
  
  attr_accessor :app_name, :version, :debug
  
  def initialize
    @app_name = "MyApp"
    @version = "1.0.0"
    @debug = false
  end
end

config1 = AppConfig.instance
config1.debug = true

config2 = AppConfig.instance

puts "Same instance? #{config1.object_id == config2.object_id}"
puts "Debug mode: #{config2.debug}"
puts "App name: #{config2.app_name}"

puts

# Example 3: Observer Pattern
puts "3. Observer Pattern"
puts "-" * 70

class TemperatureSensor
  include Observable
  
  attr_reader :temperature
  
  def temperature=(value)
    @temperature = value
    changed
    notify_observers(value)
  end
end

class DisplayObserver
  def update(temperature)
    puts "  Display: Temperature is #{temperature}°C"
  end
end

class AlertObserver
  def update(temperature)
    if temperature > 30
      puts "  🚨 Alert: High temperature! #{temperature}°C"
    elsif temperature < 0
      puts "  ❄️ Alert: Freezing temperature! #{temperature}°C"
    end
  end
end

sensor = TemperatureSensor.new
display = DisplayObserver.new
alert = AlertObserver.new

sensor.add_observer(display)
sensor.add_observer(alert)

puts "Setting temperature to 25°C:"
sensor.temperature = 25

puts "\nSetting temperature to 35°C:"
sensor.temperature = 35

puts "\nSetting temperature to -5°C:"
sensor.temperature = -5

puts

# Example 4: Factory Pattern
puts "4. Factory Pattern"
puts "-" * 70

class ShapeFactory
  def self.create(type, *args)
    case type
    when :circle
      Circle.new(args[0])
    when :rectangle
      Rectangle.new(args[0], args[1])
    when :square
      Square.new(args[0])
    else
      raise "Unknown shape: #{type}"
    end
  end
end

class Circle
  def initialize(radius)
    @radius = radius
  end
  
  def area
    Math::PI * @radius ** 2
  end
  
  def description
    "Circle with radius #{@radius}"
  end
end

class Rectangle
  def initialize(width, height)
    @width = width
    @height = height
  end
  
  def area
    @width * @height
  end
  
  def description
    "Rectangle #{@width}x#{@height}"
  end
end

class Square
  def initialize(side)
    @side = side
  end
  
  def area
    @side ** 2
  end
  
  def description
    "Square #{@side}x#{@side}"
  end
end

circle = ShapeFactory.create(:circle, 5)
rectangle = ShapeFactory.create(:rectangle, 4, 6)
square = ShapeFactory.create(:square, 5)

[circle, rectangle, square].each do |shape|
  puts "#{shape.description}: Area = #{shape.area.round(2)}"
end

puts

# Example 5: Builder Pattern
puts "5. Builder Pattern"
puts "-" * 70

class EmailBuilder
  def initialize
    @to = []
    @cc = []
    @subject = ""
    @body = ""
  end
  
  def to(*recipients)
    @to += recipients
    self
  end
  
  def cc(*recipients)
    @cc += recipients
    self
  end
  
  def subject(text)
    @subject = text
    self
  end
  
  def body(text)
    @body = text
    self
  end
  
  def build
    "To: #{@to.join(', ')}\n" +
    "CC: #{@cc.join(', ')}\n" +
    "Subject: #{@subject}\n" +
    "---\n#{@body}"
  end
end

email = EmailBuilder.new
  .to("alice@example.com", "bob@example.com")
  .cc("charlie@example.com")
  .subject("Meeting Tomorrow")
  .body("Don't forget about the meeting at 10 AM.")
  .build

puts email

puts

# Example 6: Service Object Pattern
puts "6. Service Object Pattern"
puts "-" * 70

class OrderProcessingService
  def initialize(order_params)
    @params = order_params
  end
  
  def call
    return failure("Invalid params") unless valid?
    
    validate_inventory
    calculate_total
    process_payment
    create_shipment
    
    success("Order processed successfully")
  rescue => e
    failure(e.message)
  end
  
  private
  
  def valid?
    @params[:items]&.any? && @params[:customer]
  end
  
  def validate_inventory
    puts "  ✓ Validating inventory"
  end
  
  def calculate_total
    @total = @params[:items].sum { |item| item[:price] * item[:qty] }
    puts "  ✓ Total calculated: $#{@total}"
  end
  
  def process_payment
    puts "  ✓ Payment processed: $#{@total}"
  end
  
  def create_shipment
    puts "  ✓ Shipment created"
  end
  
  def success(message)
    { success: true, message: message, total: @total }
  end
  
  def failure(error)
    { success: false, error: error }
  end
end

result = OrderProcessingService.new(
  customer: "Alice",
  items: [
    { name: "Book", price: 20, qty: 2 },
    { name: "Pen", price: 5, qty: 3 }
  ]
).call

if result[:success]
  puts "✓ #{result[:message]}"
  puts "  Total: $#{result[:total]}"
else
  puts "✗ Error: #{result[:error]}"
end

puts

# Example 7: Strategy Pattern
puts "7. Strategy Pattern"
puts "-" * 70

class PaymentContext
  attr_writer :strategy
  
  def execute_payment(amount)
    @strategy.pay(amount)
  end
end

class CreditCardStrategy
  def pay(amount)
    "Paid $#{amount} with Credit Card"
  end
end

class PayPalStrategy
  def pay(amount)
    "Paid $#{amount} with PayPal"
  end
end

class BitcoinStrategy
  def pay(amount)
    "Paid $#{amount} with Bitcoin"
  end
end

context = PaymentContext.new

context.strategy = CreditCardStrategy.new
puts context.execute_payment(100)

context.strategy = PayPalStrategy.new
puts context.execute_payment(200)

context.strategy = BitcoinStrategy.new
puts context.execute_payment(300)

puts

# Example 8: Command Pattern
puts "8. Command Pattern"
puts "-" * 70

class Light
  def on
    puts "  💡 Light is ON"
  end
  
  def off
    puts "  💡 Light is OFF"
  end
end

class LightOnCommand
  def initialize(light)
    @light = light
  end
  
  def execute
    @light.on
  end
  
  def undo
    @light.off
  end
end

class LightOffCommand
  def initialize(light)
    @light = light
  end
  
  def execute
    @light.off
  end
  
  def undo
    @light.on
  end
end

class RemoteControl
  def initialize
    @history = []
  end
  
  def press(command)
    command.execute
    @history << command
  end
  
  def undo
    @history.pop&.undo
  end
end

light = Light.new
remote = RemoteControl.new

on_command = LightOnCommand.new(light)
off_command = LightOffCommand.new(light)

puts "Pressing ON button:"
remote.press(on_command)

puts "\nPressing OFF button:"
remote.press(off_command)

puts "\nUndo last command:"
remote.undo

puts

puts "=" * 70
puts "Design Patterns practice complete!"
puts "=" * 70
puts
puts "Patterns Covered:"
puts "✓ Decorator (SimpleDelegator)"
puts "✓ Singleton"
puts "✓ Observer"
puts "✓ Factory"
puts "✓ Builder"
puts "✓ Service Object"
puts "✓ Strategy"
puts "✓ Command"
