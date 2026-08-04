module Api
  class FabricsController < BaseController
    def index
      authorize Fabric

      fabrics = policy_scope(Fabric).includes(:vendor).order(:name)
      render_success(fabrics.map { |fabric| FabricSerializer.new(fabric).as_json }, total_count: fabrics.size)
    end

    def availability
      fabric = Fabric.find(params[:id])
      authorize fabric

      reserved = fabric.reserved_quantity
      render_success({
        fabric_id: fabric.id,
        name: fabric.name,
        reserved_quantity: reserved.to_f,
        reserved_value_cents: fabric.cost_cents_for(reserved)
      })
    end
  end
end
