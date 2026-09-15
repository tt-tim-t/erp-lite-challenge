module StylePurchaseOrders
  # Recomputes the persisted SPO rollups (total_units, total_cost_cents) from its
  # colorway items. Called from ColorwayItem callbacks whenever a change could
  # move the totals. Totals are frozen once the SPO leaves an editable state.
  class RecalculateTotals < ApplicationService
    def initialize(style_purchase_order)
      @style_purchase_order = style_purchase_order
    end

    def call
      return unless style_purchase_order.editable?

      items = style_purchase_order.colorway_items
      style_purchase_order.update!(
        total_units: items.sum(:units_requested),
        total_cost_cents: items.sum(:extended_cost_cents)
      )
    end

    private

    attr_reader :style_purchase_order
  end
end
