# Agent guide

Instructions for AI coding agents working in ERP Lite. Humans should read it too.

This file is the source of truth for conventions and domain rules in this repo. `.github/copilot-instructions.md` was copied over from the old monolith and is out of date; where the two disagree, this file wins.

Directory guides with more detail:

- `app/models/AGENTS.md`: state machines, callback chains, concerns
- `app/services/AGENTS.md`: service objects and transactions
- `spec/AGENTS.md`: testing conventions

## Commands

| Task | Command |
| --- | --- |
| Set up, or rebuild the seed data | `bin/setup`, `bin/setup --reset` |
| Run one spec file | `bundle exec rspec spec/path/to/file_spec.rb` |
| Run the suite | `bundle exec rspec` |
| Security scan | `bundle exec brakeman -q` |
| Console and one-off scripts | `bin/rails console`, `bin/rails runner '...'` |

The README lists the seeded users and explains the `X-User-Email` header.

## Domain glossary

| Term | Meaning |
| --- | --- |
| SPO | Style purchase order: one style ordered from one garment vendor for one sales channel (`style_purchase_orders`). |
| Colorway item | One colorway of the style on an SPO, with its units, delivery dates, and its own cost sheet (`colorway_items`). These are the SPO's lines. |
| Colorway style | A style in a colorway, e.g. RF-1042 Marlowe Midi Dress in Ivory (`colorway_styles`). |
| Cost sheet | The cost groups and costs on one colorway item. There is no `cost_sheets` table: a cost sheet is `cost_groups` plus `costs` plus `colorway_items.cost_sheet_state`. |
| Cost group | One of fabric, trim, labor, freight, or duty. |
| Landed cost | What one unit costs to make and land in our warehouse: the sum of every cost group's extended value. |
| Loss rate | Waste allowance. Extended value = base value x (1 + loss rate). |
| Lane | A vendor is domestic or overseas. The lane decides how an SPO reaches the vendor. |
| Material | One line of a colorway item's bill of materials: a fabric or trim and the yield needed per unit. |
| Reservation | Fabric held for a material once its SPO goes to production. |
| Sales channel | Consumer channels are named for the brand and distribution center, e.g. "Reformation (BRD)". Partner-named channels, e.g. "Nordstrom (BRD)", are wholesale. |
| BRD, VRN, CVH | Distribution centers. BRD and VRN serve domestic ecommerce; CVH serves Europe. |
| NetSuite | The finance system of record. Overseas SPOs become NetSuite purchase orders. |

## Domain rules agents get wrong

1. **Actual cost.** Cost sheet values are estimates until the cost sheet reaches `cost_sheet_locked`. Locking is what turns them into the item's actual costs. The actual landed cost per unit is the sum of `costs.extended_value_cents` on a locked colorway item, which `ColorwayItem#actual_cost_per_unit_cents` returns. An unlocked item has no actual cost yet.
2. **`costs.actualized_value_cents` is not the actual cost.** Despite the name, it is a legacy reconciliation column written by a retired invoice-matching job. It is empty on most rows and stale on the rest. Never use it for reporting.
3. **SPO totals are persisted rollups.** `total_units` and `total_cost_cents` roll up the SPO's active (not canceled) colorway items. `StylePurchaseOrders::RecalculateTotals` keeps them in sync while the SPO is editable (`created`, `review`, `rejected`). Once the SPO is sent to production the totals are frozen, and a validation rejects changes. See `docs/decisions/0001-persist-spo-totals.md`.
4. **Unit cost is a snapshot.** `colorway_items.unit_cost_cents` follows the cost sheet until the sheet locks, then never moves.
5. **Money is integer cents** in `*_cents` columns. The one exception is `fabrics.price`, a legacy float in dollars that is waiting to be migrated. Do not copy that pattern. See `docs/decisions/0002-money-in-integer-cents.md`.
6. **Lanes.** Domestic SPOs are emailed to the vendor (`vendor_email_sent_at`). Overseas SPOs are created in NetSuite (`netsuite_id`, `costs.po_triggered_at`).

## Code conventions

- Controllers stay thin. Business logic lives in service objects under `app/services`.
- Every API action calls `authorize`, and `index` actions also use `policy_scope`. `Api::BaseController` runs `verify_authorized` after every action; do not skip it.
- Responses use `{ success: true, data:, totalCount: }` or `{ success: false, errors: [] }` through the `render_*` helpers in `Api::BaseController`.
- Never interpolate input into SQL. Use bind parameters or hash conditions.
- Never rescue `save!`, or any other bang method, inside a `transaction` block. Validate first, or let the exception escape so the transaction rolls back.
- Preload the associations you use in loops. Query methods on an association (`where`, `order`, `sum`, `count`, `find_by`) always hit the database, even when the association was preloaded.
- Iterate over large tables with `find_each`.
- Jobs retry, so every job must be safe to run twice.
- Every foreign key used in a lookup or join needs an index.

## Before you say "done"

- Add or update a spec that fails without your change, and watch it fail.
- Run the spec files for everything you touched, then `bundle exec brakeman -q`.
- Say what you verified and how. "Should work" is not verification.
