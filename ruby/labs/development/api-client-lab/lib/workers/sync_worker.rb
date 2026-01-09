# frozen_string_literal: true

require 'sidekiq'
require_relative '../api_client'

# SyncWorker is a Sidekiq background worker that syncs repository data
# asynchronously, demonstrating the Background Job pattern.
#
# Design Patterns:
# - Background Job: Asynchronous processing
# - Worker Pattern: Dedicated worker for specific tasks
#
# Example:
#   # Queue a job
#   SyncWorker.perform_async('rails/rails')
#
#   # Start worker: bundle exec sidekiq -r ./lib/workers/sync_worker.rb
class SyncWorker
  include Sidekiq::Worker

  sidekiq_options retry: 3, queue: 'default'

  # Performs the sync operation
  #
  # @param repo_full_name [String] Repository in format 'owner/name'
  def perform(repo_full_name)
    owner, name = repo_full_name.split('/')

    logger.info "Syncing repository: #{repo_full_name}"

    client = ApiClient.new
    repo_data = client.fetch_repository(owner, name)

    # In a real application, you would save this to a database
    logger.info "Synced: #{repo_data['name']} - #{repo_data['stargazers_count']} stars"

    repo_data
  rescue StandardError => e
    logger.error "Failed to sync #{repo_full_name}: #{e.message}"
    raise # Re-raise to trigger Sidekiq retry
  end
end
