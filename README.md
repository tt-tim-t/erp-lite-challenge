# ERP Lite

ERP Lite is a small extract of the ERP a fashion brand uses to develop products and place production orders. It covers styles and colorways, style purchase orders (SPOs) placed with garment vendors, per-colorway cost sheets, and fabric reservations.

It is an API-only Rails 8 app on SQLite, so it runs with nothing but Ruby installed. There is no frontend and no web server in this extract.

## Requirements

- Ruby 3.2 or newer (3.4 recommended) with Bundler
- SQLite 3 (preinstalled on macOS and most Linux distributions)

## Setup

```bash
bin/setup            # install gems, create and seed the development database
bundle exec rspec    # run the test suite
```

`bin/setup --reset` throws away the development database and rebuilds it from `db/seeds.rb`.

## Poking around

```bash
bin/rails console
bin/rails runner 'pp StylePurchaseOrder.group(:state).count'
bin/rails routes -g api
```

The API is exercised through request specs (`spec/requests`). Requests identify the caller with an `X-User-Email` header, because authentication is stubbed in this extract. The seed data has one user per role:

| Email | Role |
| --- | --- |
| `viewer@erp-lite.test` | viewer |
| `merch@erp-lite.test` | merchandiser |
| `production@erp-lite.test` | production |
| `finance@erp-lite.test` | finance |
| `admin@erp-lite.test` | admin |

## Layout

| Path | What lives there |
| --- | --- |
| `app/models` | ActiveRecord models and their state machines |
| `app/services` | Service objects, called as `SomeService.call(...)` |
| `app/controllers/api` | JSON API controllers |
| `app/policies` | Pundit authorization policies |
| `app/serializers` | JSON serializers |
| `app/workers` | Background jobs |
| `app/gateways` | Clients for external systems (NetSuite) |
| `db` | Migrations, schema, and seed data |
| `spec` | RSpec suite and FactoryBot factories |
| `docs` | Engineering guides and decision records |
