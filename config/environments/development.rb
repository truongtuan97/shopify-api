Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => 'public, max-age=172800'
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  config.active_job.queue_adapter = :sidekiq
  #config.active_job.queue_name_prefix = 'shopify-api'
  #config.active_job.queue_name_delimiter = '_'

  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { :host => 'http://shopify-api.stagingtd.com/' }
  config.action_mailer.delivery_method = :smtp
  # SMTP settings for gmail
=begin
  config.action_mailer.smtp_settings = {
      :address              => "server-1029.wphosting.com.au",
      :port                 => 587,
      :user_name            => "no-reply@texodesign.com.au",
      :password             => "Texod3s1gn",
      :authentication       => "plain",
      :enable_starttls_auto => true
  }
=end

  config.action_mailer.smtp_settings = {
      :address              => "smtp.office365.com",
      :port                 => 587,
      :user_name            => "smtp.relay@lesmills.com",
      :password             => "Office365",
      :authentication       => "plain",
      :enable_starttls_auto => true
  }

  #config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load
  config.host = 'http://shopify-api.stagingtd.com/'
  config.asset_host = 'http://shopify-api.stagingtd.com/'

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  # config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end
