# frozen_string_literal: true

# Configuration schema for validation
# This defines the expected structure and types for configuration values
CONFIG_SCHEMA = {
  'DATABASE_URL' => {
    type: :string,
    required: true,
    pattern: /\A(postgres|mysql|sqlite):\/\//
  },
  'PORT' => {
    type: :integer,
    required: false,
    default: 3000,
    min: 1,
    max: 65_535
  },
  'HOST' => {
    type: :string,
    required: false,
    default: 'localhost'
  },
  'ENCRYPTION_KEY' => {
    type: :string,
    required: false
  },
  'SECRET_KEY_BASE' => {
    type: :string,
    required: true
  },
  'ENABLE_SSL' => {
    type: :boolean,
    required: false,
    default: false
  },
  'DEBUG_MODE' => {
    type: :boolean,
    required: false,
    default: false
  }
}.freeze
