# Exercise 3: Mocking External Services

Master test doubles, mocks, and stubs to isolate your tests from external dependencies.

## 🎯 Objectives

- Use test doubles to replace real objects
- Mock external API calls
- Stub methods with canned responses
- Verify method calls with expectations
- Test error scenarios without real failures
- Speed up tests by avoiding network calls

## 📝 Part 1: Payment Gateway Mocking

Test payment processing without charging real cards.

### Payment Service

```ruby
# app/services/payment_processor.rb
class PaymentProcessor
  def initialize(gateway: PaymentGateway.new)
    @gateway = gateway
  end

  def process(order)
    result = @gateway.charge(
      amount: order.total,
      currency: 'USD',
      card_token: order.payment_token,
      description: "Order ##{order.id}"
    )

    if result[:success]
      order.update(
        status: 'paid',
        transaction_id: result[:transaction_id],
        paid_at: Time.now
      )
      OrderMailer.send_confirmation(order).deliver_later
      { success: true }
    else
      order.update(status: 'payment_failed', error_message: result[:error])
      { success: false, error: result[:error] }
    end
  rescue PaymentGateway::NetworkError => e
    order.update(status: 'payment_pending', error_message: e.message)
    { success: false, error: 'Network error, please try again' }
  end
end
```

### Test with Mocks

```ruby
# spec/services/payment_processor_spec.rb
require 'rails_helper'

RSpec.describe PaymentProcessor do
  let(:order) { create(:order, total: 100.00, payment_token: 'tok_123') }
  let(:gateway) { instance_double('PaymentGateway') }
  let(:mailer) { instance_double(ActionMailer::MessageDelivery) }

  subject(:processor) { described_class.new(gateway: gateway) }

  before do
    allow(OrderMailer).to receive(:send_confirmation).and_return(mailer)
    allow(mailer).to receive(:deliver_later)
  end

  describe '#process' do
    context 'with successful payment' do
      before do
        allow(gateway).to receive(:charge).and_return({
          success: true,
          transaction_id: 'txn_12345'
        })
      end

      it 'charges the payment gateway' do
        processor.process(order)

        expect(gateway).to have_received(:charge).with(
          amount: 100.00,
          currency: 'USD',
          card_token: 'tok_123',
          description: "Order ##{order.id}"
        )
      end

      it 'updates order status to paid' do
        processor.process(order)

        expect(order.reload.status).to eq('paid')
        expect(order.transaction_id).to eq('txn_12345')
        expect(order.paid_at).to be_present
      end

      it 'sends confirmation email' do
        processor.process(order)

        expect(OrderMailer).to have_received(:send_confirmation).with(order)
        expect(mailer).to have_received(:deliver_later)
      end

      it 'returns success result' do
        result = processor.process(order)

        expect(result[:success]).to be true
      end
    end

    context 'with payment failure' do
      before do
        allow(gateway).to receive(:charge).and_return({
          success: false,
          error: 'Insufficient funds'
        })
      end

      it 'updates order status to failed' do
        processor.process(order)

        expect(order.reload.status).to eq('payment_failed')
        expect(order.error_message).to eq('Insufficient funds')
      end

      it 'does not send confirmation email' do
        processor.process(order)

        expect(OrderMailer).not_to have_received(:send_confirmation)
      end

      it 'returns failure result' do
        result = processor.process(order)

        expect(result[:success]).to be false
        expect(result[:error]).to eq('Insufficient funds')
      end
    end

    context 'with network error' do
      before do
        allow(gateway).to receive(:charge)
          .and_raise(PaymentGateway::NetworkError, 'Connection timeout')
      end

      it 'marks order as pending' do
        processor.process(order)

        expect(order.reload.status).to eq('payment_pending')
      end

      it 'returns error message' do
        result = processor.process(order)

        expect(result[:success]).to be false
        expect(result[:error]).to eq('Network error, please try again')
      end
    end
  end
end
```

## 📝 Part 2: Email Service Mocking

Test email sending without actually sending emails.

### Email Verification Service

```ruby
# app/services/email_verification_service.rb
class EmailVerificationService
  def initialize(email_validator: EmailValidator.new)
    @email_validator = email_validator
  end

  def verify(email)
    # Check format
    return { valid: false, reason: 'Invalid format' } unless valid_format?(email)

    # Check if email exists (external API call)
    result = @email_validator.check_deliverability(email)

    if result[:deliverable]
      { valid: true, provider: result[:provider] }
    else
      { valid: false, reason: result[:reason] }
    end
  rescue EmailValidator::RateLimitError
    { valid: nil, reason: 'Rate limit exceeded, try again later' }
  end

  private

  def valid_format?(email)
    email.match?(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i)
  end
end
```

### Your Task: Write Tests

```ruby
# spec/services/email_verification_service_spec.rb
require 'rails_helper'

RSpec.describe EmailVerificationService do
  let(:email_validator) { instance_double('EmailValidator') }
  subject(:service) { described_class.new(email_validator: email_validator) }

  describe '#verify' do
    context 'with valid deliverable email' do
      # TODO: Stub email_validator.check_deliverability to return deliverable: true
      # TODO: Test that it returns valid: true
      # TODO: Test that it includes the provider
    end

    context 'with invalid format' do
      # TODO: Test that it returns valid: false for 'not-an-email'
      # TODO: Test that it doesn't call the external API
    end

    context 'with non-deliverable email' do
      # TODO: Stub email_validator to return deliverable: false
      # TODO: Test that it returns valid: false with reason
    end

    context 'when rate limit is exceeded' do
      # TODO: Stub email_validator to raise EmailValidator::RateLimitError
      # TODO: Test that it returns valid: nil with error message
    end
  end
end
```

## 📝 Part 3: External API Mocking

Test API clients without making real HTTP requests.

### Weather Service

```ruby
# app/services/weather_service.rb
class WeatherService
  def initialize(http_client: HTTPClient.new)
    @http_client = http_client
  end

  def current_weather(city)
    response = @http_client.get(
      'https://api.weather.com/v1/current',
      params: { city: city, apikey: ENV['WEATHER_API_KEY'] }
    )

    if response.status == 200
      data = JSON.parse(response.body)
      {
        temperature: data['temp'],
        condition: data['condition'],
        humidity: data['humidity']
      }
    elsif response.status == 404
      { error: 'City not found' }
    else
      { error: 'Service unavailable' }
    end
  rescue HTTPClient::TimeoutError
    { error: 'Request timeout' }
  end
end
```

### Test with Stubbed HTTP Calls

```ruby
# spec/services/weather_service_spec.rb
require 'rails_helper'

RSpec.describe WeatherService do
  let(:http_client) { instance_double('HTTPClient') }
  subject(:service) { described_class.new(http_client: http_client) }

  describe '#current_weather' do
    context 'with successful response' do
      let(:response_body) do
        {
          temp: 72,
          condition: 'Sunny',
          humidity: 45
        }.to_json
      end

      let(:response) do
        double('Response', status: 200, body: response_body)
      end

      before do
        allow(http_client).to receive(:get).and_return(response)
      end

      it 'fetches weather data' do
        service.current_weather('Portland')

        expect(http_client).to have_received(:get).with(
          'https://api.weather.com/v1/current',
          params: { city: 'Portland', apikey: ENV['WEATHER_API_KEY'] }
        )
      end

      it 'returns weather information' do
        result = service.current_weather('Portland')

        expect(result[:temperature]).to eq(72)
        expect(result[:condition]).to eq('Sunny')
        expect(result[:humidity]).to eq(45)
      end
    end

    context 'when city is not found' do
      let(:response) { double('Response', status: 404, body: '') }

      before do
        allow(http_client).to receive(:get).and_return(response)
      end

      it 'returns error message' do
        result = service.current_weather('InvalidCity')

        expect(result[:error]).to eq('City not found')
      end
    end

    context 'when service is unavailable' do
      let(:response) { double('Response', status: 500, body: '') }

      before do
        allow(http_client).to receive(:get).and_return(response)
      end

      it 'returns error message' do
        result = service.current_weather('Portland')

        expect(result[:error]).to eq('Service unavailable')
      end
    end

    context 'when request times out' do
      before do
        allow(http_client).to receive(:get)
          .and_raise(HTTPClient::TimeoutError)
      end

      it 'returns timeout error' do
        result = service.current_weather('Portland')

        expect(result[:error]).to eq('Request timeout')
      end
    end
  end
end
```

## 📝 Part 4: File System Mocking

Test file operations without touching the real file system.

### File Upload Service

```ruby
# app/services/file_upload_service.rb
class FileUploadService
  def initialize(storage: Storage.new, file_system: File)
    @storage = storage
    @file_system = file_system
  end

  def upload(file, user)
    # Validate file
    return { success: false, error: 'File too large' } if file.size > 10.megabytes
    return { success: false, error: 'Invalid file type' } unless valid_type?(file)

    # Generate unique filename
    filename = generate_filename(file.original_filename)

    # Upload to storage
    url = @storage.upload(file.path, filename)

    # Create database record
    attachment = user.attachments.create!(
      filename: filename,
      url: url,
      size: file.size,
      content_type: file.content_type
    )

    # Clean up temp file
    @file_system.delete(file.path)

    { success: true, attachment: attachment }
  rescue Storage::UploadError => e
    { success: false, error: "Upload failed: #{e.message}" }
  end

  private

  def valid_type?(file)
    %w[image/jpeg image/png image/gif application/pdf].include?(file.content_type)
  end

  def generate_filename(original_filename)
    ext = @file_system.extname(original_filename)
    "#{SecureRandom.uuid}#{ext}"
  end
end
```

### Your Task: Write Tests

```ruby
# spec/services/file_upload_service_spec.rb
require 'rails_helper'

RSpec.describe FileUploadService do
  let(:storage) { instance_double('Storage') }
  let(:file_system) { class_double('File') }
  let(:user) { create(:user) }

  subject(:service) do
    described_class.new(storage: storage, file_system: file_system)
  end

  describe '#upload' do
    let(:file) do
      double('File',
        original_filename: 'photo.jpg',
        path: '/tmp/upload123',
        size: 2.megabytes,
        content_type: 'image/jpeg'
      )
    end

    context 'with valid file' do
      # TODO: Stub SecureRandom.uuid to return predictable value
      # TODO: Stub file_system.extname to return '.jpg'
      # TODO: Stub storage.upload to return a URL
      # TODO: Stub file_system.delete
      # TODO: Test that file is uploaded to storage
      # TODO: Test that attachment record is created
      # TODO: Test that temp file is deleted
      # TODO: Test that success is returned
    end

    context 'when file is too large' do
      # TODO: Create file double with size > 10MB
      # TODO: Test that it returns error without uploading
      # TODO: Test that storage.upload is NOT called
    end

    context 'when file type is invalid' do
      # TODO: Create file with invalid content_type
      # TODO: Test that it returns error
      # TODO: Test that upload doesn't proceed
    end

    context 'when storage upload fails' do
      # TODO: Stub storage.upload to raise Storage::UploadError
      # TODO: Test that it returns error with message
      # TODO: Test that temp file is NOT deleted
    end
  end
end
```

## 📝 Part 5: Time-Based Testing

Test time-dependent code without waiting.

### Subscription Service

```ruby
# app/services/subscription_service.rb
class SubscriptionService
  def renew(subscription)
    return false if subscription.expires_at > Time.now

    subscription.update!(
      expires_at: 1.year.from_now,
      renewed_at: Time.now
    )

    true
  end

  def days_until_expiration(subscription)
    return 0 if expired?(subscription)

    ((subscription.expires_at - Time.now) / 1.day).ceil
  end

  def expired?(subscription)
    subscription.expires_at < Time.now
  end
end
```

### Test with Time Manipulation

```ruby
# spec/services/subscription_service_spec.rb
require 'rails_helper'

RSpec.describe SubscriptionService do
  subject(:service) { described_class.new }

  describe '#renew' do
    it 'renews expired subscription' do
      subscription = create(:subscription, expires_at: 1.day.ago)

      result = service.renew(subscription)

      expect(result).to be true
      expect(subscription.reload.expires_at).to be > Time.now
    end

    it 'does not renew active subscription' do
      subscription = create(:subscription, expires_at: 1.month.from_now)

      result = service.renew(subscription)

      expect(result).to be false
    end

    it 'sets expiration to one year from now' do
      freeze_time = Time.parse('2024-01-15 12:00:00')

      travel_to(freeze_time) do
        subscription = create(:subscription, expires_at: 1.day.ago)

        service.renew(subscription)

        expect(subscription.reload.expires_at).to eq(freeze_time + 1.year)
        expect(subscription.renewed_at).to eq(freeze_time)
      end
    end
  end

  describe '#days_until_expiration' do
    it 'calculates days until expiration' do
      subscription = create(:subscription, expires_at: 5.days.from_now)

      days = service.days_until_expiration(subscription)

      expect(days).to eq(5)
    end

    it 'returns 0 for expired subscription' do
      subscription = create(:subscription, expires_at: 1.day.ago)

      days = service.days_until_expiration(subscription)

      expect(days).to eq(0)
    end
  end

  describe '#expired?' do
    it 'returns true for expired subscription' do
      subscription = create(:subscription, expires_at: 1.hour.ago)

      expect(service.expired?(subscription)).to be true
    end

    it 'returns false for active subscription' do
      subscription = create(:subscription, expires_at: 1.hour.from_now)

      expect(service.expired?(subscription)).to be false
    end
  end
end
```

## 🎯 Challenge: Social Media Integration

Mock a complete social media posting service that:

1. **Validates Post Content**
   - Checks character limits
   - Validates image formats
   - Checks for banned words

2. **Posts to Multiple Platforms**
   - Twitter API
   - Facebook API
   - LinkedIn API

3. **Handles Failures Gracefully**
   - Retries on network errors
   - Logs failed posts
   - Notifies user of failures

4. **Tracks Analytics**
   - Records post timestamps
   - Tracks which platforms succeeded
   - Calculates engagement metrics

Write comprehensive tests that mock all external services!

## 🐍 Python Comparison

```python
# Python (unittest.mock)
from unittest.mock import Mock, patch

def test_payment_processing():
    gateway = Mock()
    gateway.charge.return_value = {'success': True, 'transaction_id': '123'}

    processor = PaymentProcessor(gateway=gateway)
    result = processor.process(order)

    gateway.charge.assert_called_with(
        amount=100.00,
        currency='USD'
    )
    assert result['success'] == True
```

```ruby
# Ruby (RSpec mocks)
RSpec.describe PaymentProcessor do
  let(:gateway) { instance_double('PaymentGateway') }

  it 'processes payment' do
    allow(gateway).to receive(:charge).and_return({
      success: true,
      transaction_id: '123'
    })

    processor = PaymentProcessor.new(gateway: gateway)
    result = processor.process(order)

    expect(gateway).to have_received(:charge).with(
      amount: 100.00,
      currency: 'USD'
    )
    expect(result[:success]).to be true
  end
end
```

## ✅ Success Criteria

- [ ] Mocked payment gateway successfully
- [ ] Tested email service without sending emails
- [ ] Stubbed HTTP client for API calls
- [ ] Mocked file system operations
- [ ] Used time manipulation for date-based tests
- [ ] Verified method calls with expectations
- [ ] Tested error scenarios with raised exceptions
- [ ] Understand when to mock vs use real objects

## 💡 Best Practices

### 1. Use Real Objects When Possible

```ruby
# Prefer
user = build_stubbed(:user)

# Over
user = double('User', name: 'Alice', email: 'alice@example.com')
```

### 2. Use instance_double for Type Safety

```ruby
# Good: Raises error if Gateway doesn't have :charge method
gateway = instance_double('PaymentGateway')
allow(gateway).to receive(:charge)

# Bad: Allows any method
gateway = double('PaymentGateway')
allow(gateway).to receive(:charge)
```

### 3. Don't Mock What You Don't Own

```ruby
# Bad: Mocking third-party library directly
stripe = double('Stripe')
allow(stripe).to receive(:charge)

# Good: Wrap in your own class and mock that
gateway = instance_double('PaymentGateway')
allow(gateway).to receive(:charge)
```

### 4. Verify Important Interactions

```ruby
# Test that important methods are called
expect(mailer).to have_received(:send_email)

# But don't over-specify
expect(gateway).to have_received(:charge)  # Good
expect(gateway).to have_received(:charge).exactly(1).times  # Overkill
```

## 📖 RSpec Mock Methods

| Method | Purpose | Example |
|--------|---------|---------|
| `double` | Create test double | `double('User')` |
| `instance_double` | Type-safe double | `instance_double('User')` |
| `class_double` | Mock class methods | `class_double('File')` |
| `spy` | Verify after calling | `spy('Logger')` |
| `allow().to receive` | Stub method | `allow(obj).to receive(:method)` |
| `expect().to receive` | Mock method | `expect(obj).to receive(:method)` |
| `and_return` | Return value | `.and_return(42)` |
| `and_raise` | Raise exception | `.and_raise(Error)` |
| `with` | Match arguments | `.with(1, 2)` |
| `have_received` | Verify spy | `expect(spy).to have_received(:method)` |

---

**Mocking keeps your tests fast and reliable!** Use it wisely. 🎭
