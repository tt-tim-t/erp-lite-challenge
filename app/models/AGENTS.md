# Models: notes for agents

Read `docs/agents/README.md` first. This file covers what is specific to models.

## State machines

Built on `state_machines-activerecord`. Each machine lives next to its model as `<model>_state_machine.rb`.

- `StylePurchaseOrderStateMachine` (`state`): created -> review -> production -> completed. Review can go to rejected and back. Anything except completed can be canceled. The important side effects of moving an SPO live in this machine's `after_transition` callbacks, not in controllers or services. Read it before changing what happens when an SPO moves.
- `ColorwayItemStateMachine` (`cost_sheet_state`): draft -> cost_sheet_approved -> cost_sheet_locked. Locking is one-way.
- `ReservationStateMachine` (`state`): enabled, disabled, closed.

Bang events such as `send_to_production!` raise `StateMachines::InvalidTransition` when the transition is not allowed. The non-bang versions return false.

## Callback chains

Saving a cost cascades all the way up to the SPO:

```
Cost#save
  -> CostGroup#recalculate!
    -> ColorwayItem#refresh_unit_cost!   (skipped once the cost sheet is locked)
      -> ColorwayItem#save
        -> StylePurchaseOrders::RecalculateTotals   (skipped once the SPO leaves review)
```

`update_all` and `update_columns` skip this chain. If you use them, recalculate by hand.

## Concerns

- `EventLoggable` writes an `event_logs` row after commit whenever the model's state attribute changes: `state` on SPOs, `cost_sheet_state` on colorway items.

## Scopes worth knowing

`ColorwayItem.active` (not canceled), `ColorwayItem.upcoming`, `Reservation.enabled`, `Vendor.active`, `SalesChannel.consumer`, `SalesChannel.wholesale`.
