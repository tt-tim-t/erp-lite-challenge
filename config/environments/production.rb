require "active_support/core_ext/integer/time"

# ERP Lite is never deployed. This file exists so the app boots with
# RAILS_ENV=production for eager-loading checks.
Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.force_ssl = true
  config.log_level = :info
  config.active_job.queue_adapter = :async
  config.i18n.fallbacks = true
  config.active_record.dump_schema_after_migration = false
end
