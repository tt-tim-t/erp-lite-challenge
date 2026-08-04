class StylePurchaseOrderSerializer
  def initialize(style_purchase_order, include_items: false)
    @style_purchase_order = style_purchase_order
    @include_items = include_items
  end

  def as_json(*)
    data = {
      id: spo.id,
      po_number: spo.po_number,
      state: spo.state,
      style_number: spo.style.style_number,
      style_name: spo.style.name,
      vendor: spo.vendor.name,
      vendor_lane: spo.vendor.lane,
      sales_channel: spo.sales_channel.name,
      owner: spo.owner.name,
      total_units: spo.total_units,
      total_cost_cents: spo.total_cost_cents,
      active_item_count: spo.colorway_items.active.count,
      netsuite_id: spo.netsuite_id
    }
    data[:colorway_items] = colorway_items if include_items
    data
  end

  private

  attr_reader :include_items

  def spo
    @style_purchase_order
  end

  def colorway_items
    spo.colorway_items.active.includes(colorway_style: %i[style colorway]).order(:id).map do |item|
      ColorwayItemSerializer.new(item).as_json
    end
  end
end
