module CostSheets
  # Builds the fabric and trim cost groups for a colorway item from its bill of
  # materials. Labor, freight, and duty costs are entered by hand.
  class BuildFromMaterials < ApplicationService
    MATERIAL_LOSS_RATE = BigDecimal("0.03")

    def initialize(colorway_item)
      @colorway_item = colorway_item
    end

    def call
      ColorwayItem.transaction do
        Fabric::FABRIC_TYPES.each do |group_type|
          group = colorway_item.cost_groups.find_or_create_by!(group_type:)
          group.costs.where.not(fabric_id: nil).destroy_all

          materials_of_type(group_type).each do |material|
            group.costs.create!(
              name: material.fabric.name,
              fabric: material.fabric,
              vendor_id: material.fabric.vendor_id,
              base_value_cents: material.fabric.cost_cents_for(material.estimated_yield),
              loss_rate: MATERIAL_LOSS_RATE
            )
          end
        end
      end
    end

    private

    attr_reader :colorway_item

    def materials_of_type(group_type)
      colorway_item.materials.active.includes(:fabric).select do |material|
        material.fabric.fabric_type == group_type
      end
    end
  end
end
