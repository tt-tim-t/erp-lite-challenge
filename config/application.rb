require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ErpLite
  class Application < Rails::Application
    config.load_defaults 8.0

    config.autoload_lib(ignore: %w[assets tasks])

    config.api_only = true
    config.time_zone = "Pacific Time (US & Canada)"

    # Production runs these jobs on Sidekiq. Locally they run inline so their
    # side effects are visible as soon as the request (or seed) finishes.
    config.active_job.queue_adapter = :inline

    config.action_mailer.default_options = { from: "production@erp-lite.test" }

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot, dir: "spec/factories"
    end
  end
end
