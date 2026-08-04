source "https://rubygems.org"

gem "rails", "~> 8.0.5"
gem "sqlite3", ">= 2.1"
gem "pundit", "~> 2.4"
gem "state_machines-activerecord", "~> 0.8"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[windows jruby]

group :development, :test do
  gem "rspec-rails", "~> 8.0"
  gem "factory_bot_rails", "~> 6.4"
end

group :development do
  gem "brakeman", require: false
end
