# Services: notes for agents

Read `docs/agents/README.md` first.

- Inherit from `ApplicationService`, implement `initialize` and `call`, and call it as `SomeService.call(...)`.
- Return `ServiceResult.success` or `ServiceResult.failure(messages)` for business failures that the caller should show to a user. Raise for programming errors.
- Wrap multi-record writes in one transaction, and never rescue inside the transaction block.
- Keep external calls (NetSuite, email) out of transactions. Enqueue a job instead; `ApplicationJob` waits for the surrounding transaction to commit before it enqueues.
- Namespaces mirror the model a service acts on: `StylePurchaseOrders::`, `ColorwayItems::`, `CostSheets::`, `Reservations::`, `Reports::`.
