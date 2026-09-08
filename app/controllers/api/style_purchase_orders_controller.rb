module Api
  class StylePurchaseOrdersController < BaseController
    before_action :set_style_purchase_order, except: :index

    def index
      authorize StylePurchaseOrder

      scope = policy_scope(StylePurchaseOrder).search(params[:q])
      scope = scope.where(state: params[:state]) if params[:state].present?
      scope = scope.with_upcoming_deliveries if params[:upcoming] == "true"

      records = scope.order(created_at: :desc).limit(per_page).offset((page - 1) * per_page)
      render_success(
        records.map { |spo| StylePurchaseOrderSerializer.new(spo).as_json },
        total_count: scope.count
      )
    end

    def show
      authorize @style_purchase_order
      render_success(serialized(@style_purchase_order))
    end

    def update
      authorize @style_purchase_order

      if @style_purchase_order.update(style_purchase_order_params)
        render_success(serialized(@style_purchase_order))
      else
        render_errors(@style_purchase_order.errors.full_messages)
      end
    end

    def submit_for_review
      authorize @style_purchase_order

      if @style_purchase_order.submit_for_review
        render_success(serialized(@style_purchase_order))
      else
        render_errors("#{@style_purchase_order.po_number} cannot be submitted from #{@style_purchase_order.state}")
      end
    end

    def send_to_production
      authorize @style_purchase_order

      result = StylePurchaseOrders::SendToProduction.call(@style_purchase_order, user: current_user)
      render_result(result, serialized(@style_purchase_order.reload))
    end

    def cancel
      authorize @style_purchase_order

      result = StylePurchaseOrders::Cancel.call(@style_purchase_order, reason: params[:reason])
      render_result(result, serialized(@style_purchase_order.reload))
    end

    private

    def set_style_purchase_order
      @style_purchase_order = StylePurchaseOrder.find(params[:id])
    end

    def style_purchase_order_params
      params.expect(style_purchase_order: %i[sales_channel_id owner_id])
    end

    def serialized(style_purchase_order)
      StylePurchaseOrderSerializer.new(style_purchase_order, include_items: true).as_json
    end
  end
end
