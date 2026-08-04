class ColorwayItemSerializer
  def initialize(colorway_item)
    @colorway_item = colorway_item
  end

  def as_json(*)
    {
      id: colorway_item.id,
      colorway: colorway_item.colorway_style.colorway.name,
      status: colorway_item.status,
      cost_sheet_state: colorway_item.cost_sheet_state,
      units_requested: colorway_item.units_requested,
      unit_cost_cents: colorway_item.unit_cost_cents,
      extended_cost_cents: colorway_item.extended_cost_cents,
      delivery_date: colorway_item.delivery_date
    }
  end

  private

  attr_reader :colorway_item
end
