# 1. Persist SPO totals

Status: accepted, July 2026

## Context

SPO totals appear on every list page, are sorted and filtered on, and are sent to NetSuite. Computing them from colorway items on every read was slow. Worse, it rewrote history: changing a line after an SPO was placed silently changed the total we had already committed to with the vendor.

## Decision

Persist `total_units` and `total_cost_cents` on `style_purchase_orders`. Recalculate them from the SPO's active colorway items whenever a line changes while the SPO is editable. Freeze them once the SPO is sent to production.

## Consequences

Every code path that changes a colorway item's units, unit cost, or status must trigger recalculation. The `ColorwayItem` callbacks do this; bulk updates must do it by hand.
