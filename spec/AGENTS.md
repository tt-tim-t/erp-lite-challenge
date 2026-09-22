# Specs: notes for agents

Read `docs/agents/README.md` first.

- Run single files: `bundle exec rspec spec/models/colorway_item_spec.rb`.
- Factories live in `spec/factories`. Use `build` unless the example needs the database.
- Never hardcode a calendar date to mean "in the future" or "in the past". Use relative dates (`2.weeks.from_now`) or freeze the clock with `travel_to`.
- The ActiveJob test adapter is on. Assert with `have_enqueued_job` and run jobs with `perform_enqueued_jobs`.
- The NetSuite gateway never makes network calls while `NETSUITE_BASE_URL` is unset, and it is unset in test.
- Request specs authenticate with `auth_headers(user)` and parse responses with `json_body`.
- Every behavior change gets a spec that fails without it.
