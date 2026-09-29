module Reports
  # Landed cost per unit for every active colorway item, for the finance team's
  # margin review. All associations are preloaded in #scope, so the report runs
  # a fixed number of queries no matter how many rows it returns.
  class LandedCostReport < ApplicationService
    def initialize(season: nil)
      @season = season
    end

    def call
      scope.map do |colorway_item|
        per_unit = landed_cost_per_unit_cents(colorway_item)

        {
          po_number: colorway_item.style_purchase_order.po_number,
          style_number: colorway_item.colorway_style.style.style_number,
          colorway: colorway_item.colorway_style.colorway.name,
          units: colorway_item.units_requested,
          landed_cost_per_unit_cents: per_unit,
          landed_cost_total_cents: per_unit * colorway_item.units_requested
        }
      end
    end

    private

    attr_reader :season

    def scope
      items = ColorwayItem.active.includes(
        :style_purchase_order,
        colorway_style: %i[style colorway],
        cost_groups: :costs
      )
      items = items.joins(colorway_style: :style).where(styles: { season_id: season.id }) if season
      items.order(:id)
    end

    def landed_cost_per_unit_cents(colorway_item)
      colorway_item.cost_groups.sum do |cost_group|
        cost_group.costs.where.not(actualized_value_cents: nil).sum(:actualized_value_cents)
      end
    end
  end
end
