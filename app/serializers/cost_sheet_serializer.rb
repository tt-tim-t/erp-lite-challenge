class CostSheetSerializer
  def initialize(colorway_item)
    @colorway_item = colorway_item
  end

  def as_json(*)
    {
      colorway_item_id: colorway_item.id,
      cost_sheet_state: colorway_item.cost_sheet_state,
      locked_at: colorway_item.cost_sheet_locked_at,
      unit_cost_cents: colorway_item.unit_cost_cents,
      cost_groups: colorway_item.cost_groups.includes(:costs).map do |group|
        {
          group_type: group.group_type,
          extended_value_sum_cents: group.extended_value_sum_cents,
          costs: group.costs.map { |cost| cost.slice(:id, :name, :base_value_cents, :loss_rate, :extended_value_cents) }
        }
      end
    }
  end

  private

  attr_reader :colorway_item
end
