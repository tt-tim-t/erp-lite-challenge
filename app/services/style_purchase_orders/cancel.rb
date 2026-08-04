module StylePurchaseOrders
  class Cancel < ApplicationService
    def initialize(style_purchase_order, reason:)
      @style_purchase_order = style_purchase_order
      @reason = reason
    end

    def call
      return ServiceResult.failure("A cancel reason is required") if reason.blank?
      return ServiceResult.failure("#{style_purchase_order.po_number} cannot be canceled") unless style_purchase_order.can_cancel?

      style_purchase_order.cancel_reason = reason
      style_purchase_order.cancel!
      ServiceResult.success
    end

    private

    attr_reader :style_purchase_order, :reason
  end
end
