module ColorwayItems
  # Cancels one colorway on an SPO. The line stays on the order for history
  # but no longer counts toward totals, and its fabric is released.
  class Cancel < ApplicationService
    def initialize(colorway_item)
      @colorway_item = colorway_item
    end

    def call
      return ServiceResult.failure("Already canceled") if colorway_item.canceled?

      ColorwayItem.transaction do
        colorway_item.update!(status: "canceled")
        colorway_item.reservations.enabled.find_each(&:disable!)
      end
      ServiceResult.success
    end

    private

    attr_reader :colorway_item
  end
end
