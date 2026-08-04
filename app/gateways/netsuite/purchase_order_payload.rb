module Netsuite
  # Builds the NetSuite purchase order body for an SPO.
  class PurchaseOrderPayload
    def initialize(style_purchase_order)
      @style_purchase_order = style_purchase_order
    end

    def to_h
      {
        external_reference: style_purchase_order.po_number,
        vendor_id: style_purchase_order.vendor.netsuite_id,
        lines: lines
      }
    end

    private

    attr_reader :style_purchase_order

    def lines
      style_purchase_order.colorway_items.active.includes(colorway_style: %i[style colorway]).map do |item|
        {
          item: "#{item.colorway_style.style.style_number}-#{item.colorway_style.colorway.color_code}",
          quantity: item.units_requested,
          rate_cents: item.unit_cost_cents,
          expected_receipt_date: item.delivery_date&.iso8601
        }
      end
    end
  end
end
