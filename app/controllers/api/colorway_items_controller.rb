module Api
  class ColorwayItemsController < BaseController
    before_action :set_colorway_item

    def update
      authorize @colorway_item

      if @colorway_item.update(colorway_item_params)
        render_success(ColorwayItemSerializer.new(@colorway_item).as_json)
      else
        render_errors(@colorway_item.errors.full_messages)
      end
    end

    def cancel
      authorize @colorway_item

      result = ColorwayItems::Cancel.call(@colorway_item)
      render_result(result, ColorwayItemSerializer.new(@colorway_item.reload).as_json)
    end

    private

    def set_colorway_item
      @colorway_item = ColorwayItem.find(params[:id])
    end

    def colorway_item_params
      params.expect(colorway_item: %i[units_requested revised_delivery_date])
    end
  end
end
