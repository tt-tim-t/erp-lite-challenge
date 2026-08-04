# 2. Store money as integer cents

Status: accepted, June 2026

## Context

Float arithmetic drifted by a cent on extended costs often enough to break reconciliation with NetSuite.

## Decision

Money columns are integers in cents, named `*_cents`. Multiply with `BigDecimal` and round once, at the end.

## Consequences

`fabrics.price` predates this decision. It is still a float in dollars and is scheduled to become `price_cents`.
