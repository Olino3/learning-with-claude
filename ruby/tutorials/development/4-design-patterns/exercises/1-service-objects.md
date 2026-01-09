# Exercise 1: Service Objects

Practice building service objects for complex business operations.

## Objective

Learn to extract business logic from controllers into testable, reusable service objects.

## Part 1: User Registration Service

Build a service that handles user registration with email verification.

```ruby
# app/services/users/registration_service.rb
module Users
  class RegistrationService
    # TODO: Implement service that:
    # 1. Creates user
    # 2. Generates verification token
    # 3. Sends verification email
    # 4. Returns result object
  end
end
```

<details>
<summary>Solution</summary>

```ruby
# app/services/users/registration_service.rb
module Users
  class RegistrationService
    def initialize(params:)
      @params = params
    end

    def call
      @user = User.new(params)
      return failure_result unless @user.valid?

      ActiveRecord::Base.transaction do
        @user.save!
        generate_verification_token
        send_verification_email
      end

      success_result
    rescue StandardError => e
      failure_result(error: e.message)
    end

    private

    attr_reader :params, :user

    def generate_verification_token
      user.update!(
        verification_token: SecureRandom.urlsafe_base64,
        verification_sent_at: Time.current
      )
    end

    def send_verification_email
      UserMailer.verification_email(user).deliver_later
    end

    def success_result
      ServiceResult.new(success: true, value: user)
    end

    def failure_result(error: nil)
      ServiceResult.new(
        success: false,
        error: error || user.errors.full_messages.join(', ')
      )
    end
  end
end

# spec/services/users/registration_service_spec.rb
RSpec.describe Users::RegistrationService do
  describe '#call' do
    let(:params) { attributes_for(:user) }
    subject(:service) { described_class.new(params: params) }

    it 'creates a user' do
      expect { service.call }.to change { User.count }.by(1)
    end

    it 'generates verification token' do
      result = service.call
      expect(result.value.verification_token).to be_present
    end

    it 'sends verification email' do
      expect(UserMailer).to receive(:verification_email)
        .and_return(double(deliver_later: true))
      service.call
    end
  end
end
```
</details>

## Part 2: Payment Processing Service

Create a service for processing payments with Stripe.

<details>
<summary>Solution</summary>

```ruby
# app/services/payments/process_service.rb
module Payments
  class ProcessService
    def initialize(order:, payment_method:)
      @order = order
      @payment_method = payment_method
    end

    def call
      return failure_result('Order already paid') if order.paid?

      charge_payment
      update_order
      send_receipt

      success_result
    rescue Stripe::CardError => e
      failure_result("Payment failed: #{e.message}")
    rescue StandardError => e
      failure_result("Error: #{e.message}")
    end

    private

    attr_reader :order, :payment_method

    def charge_payment
      @payment = Stripe::Charge.create(
        amount: order.total_cents,
        currency: 'usd',
        payment_method: payment_method,
        description: "Order ##{order.id}"
      )
    end

    def update_order
      order.update!(
        payment_id: @payment.id,
        status: 'paid',
        paid_at: Time.current
      )
    end

    def send_receipt
      OrderMailer.receipt(order).deliver_later
    end

    def success_result
      ServiceResult.new(success: true, value: order)
    end

    def failure_result(error)
      ServiceResult.new(success: false, error: error)
    end
  end
end
```
</details>

## Key Learnings

- Service objects have single responsibility
- Return result objects for flexibility
- Use transactions for data consistency
- Test services independently
- Handle errors gracefully

## Next Steps

Continue to **[Exercise 2: Decorators & Queries](2-decorators-queries.md)**!
