module StylePurchaseOrders
  # Moves an SPO from review into production. Every active colorway item must
  # have a locked cost sheet first. The state machine's after_transition
  # callbacks do the rest (see StylePurchaseOrderStateMachine).
  class SendToProduction < ApplicationService
    def initialize(style_purchase_order, user:)
      @style_purchase_order = style_purchase_order
      @user = user
    end

    def call
      unlocked = style_purchase_order.colorway_items.active.reject(&:cost_sheet_locked?)
      if unlocked.any?
        names = unlocked.map { |item| item.colorway_style.display_name }
        return ServiceResult.failure("Cost sheets must be locked before production: #{names.join(', ')}")
      end

      StylePurchaseOrder.transaction do
        style_purchase_order.send_to_production!
        ServiceResult.success
      rescue ActiveRecord::RecordInvalid, StateMachines::InvalidTransition => e
        ServiceResult.failure(e.message)
      end
    end

    private

    attr_reader :style_purchase_order, :user
  end
end
