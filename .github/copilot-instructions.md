# Copilot instructions

Notes for the ERP monolith. Last reviewed November 2025.

- Tests use Minitest. Run them with `bin/rails test`.
- Money is stored as decimal dollars (`price`, `base_value`). Format it with `number_to_currency`.
- Actual costs live in `costs.actualized_value`. Use them for margin and landed-cost reporting.
- Background jobs are Sidekiq workers (`include Sidekiq::Worker`) in `app/workers`.
- SPO totals are calculated on the fly. Never store them.
