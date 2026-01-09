# Lab 4: Secure Config Manager

A production-quality configuration management tool demonstrating security best practices, encryption, validation, and safe handling of sensitive data.

## Learning Objectives

- **Security Best Practices**: Handling sensitive configuration data
- **Encryption**: Implementing symmetric encryption for secrets
- **Validation**: Ensuring configuration integrity
- **Environment Variables**: Using dotenv for configuration
- **Error Handling**: Secure error messages that don't leak secrets
- **Design Patterns**: Service objects, validators, loaders

## Project Structure

```
config-manager-lab/
├── lib/
│   ├── config_manager.rb         # Main configuration manager
│   ├── encryption/
│   │   └── encryptor.rb          # Encryption service
│   ├── validators/
│   │   └── config_validator.rb   # Configuration validator
│   └── loaders/
│       └── env_loader.rb         # Environment loader
├── config/
│   └── schema.rb                 # Configuration schema
├── spec/                         # Test suite
├── .env.example                  # Example environment file
└── README.md
```

## Design Patterns

### 1. Service Object Pattern
Encapsulates encryption and validation logic in dedicated services.

### 2. Validator Pattern
Validates configuration against defined schemas.

### 3. Loader Pattern
Abstracts configuration loading from different sources.

## Setup Instructions

1. **Install dependencies**:
   ```bash
   bundle install
   ```

2. **Create environment file**:
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

3. **Run tests**:
   ```bash
   bundle exec rspec
   ```

## Usage Examples

### Basic Configuration Management

```ruby
require_relative 'lib/config_manager'

# Load configuration
config = ConfigManager.new
puts config.get('DATABASE_URL')
puts config.get('API_KEY')
```

### With Encryption

```ruby
# Encrypt sensitive value
encrypted = config.encrypt('my-secret-value')

# Decrypt when needed
decrypted = config.decrypt(encrypted)
```

### With Validation

```ruby
# Validate configuration
config.validate!
# Raises error if invalid

# Check specific key
config.valid_key?('DATABASE_URL')
```

## Security Features

1. **Encryption**: AES-256-GCM encryption for secrets
2. **Validation**: Schema-based validation
3. **Secure Errors**: Error messages don't leak sensitive data
4. **Masking**: Automatic masking in logs
5. **Type Safety**: Type-checked configuration values

## Testing

```bash
# Run all tests
bundle exec rspec

# Run with coverage
bundle exec rake coverage
```

## Best Practices Demonstrated

- Never commit .env files
- Use strong encryption
- Validate all configuration
- Mask secrets in logs
- Fail fast on invalid config
- Use environment variables for deployment

## License

Educational use only.
