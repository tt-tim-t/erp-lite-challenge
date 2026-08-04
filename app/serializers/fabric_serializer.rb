class FabricSerializer
  def initialize(fabric)
    @fabric = fabric
  end

  def as_json(*)
    {
      id: fabric.id,
      name: fabric.name,
      fabric_type: fabric.fabric_type,
      measurement_units: fabric.measurement_units,
      price: fabric.price,
      vendor: fabric.vendor&.name
    }
  end

  private

  attr_reader :fabric
end
