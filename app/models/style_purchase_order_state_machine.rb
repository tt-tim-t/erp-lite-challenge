# Lifecycle of a style purchase order.
#
#   created -> review -> production -> completed
#                 \-> rejected -> review
#   any state except completed -> canceled
module StylePurchaseOrderStateMachine
  extend ActiveSupport::Concern

  included do
    state_machine :state, initial: :created do
      before_transition any => :production do |style_purchase_order, _transition|
        style_purchase_order.sent_to_production_at = Time.current
      end

      after_transition any => :production do |style_purchase_order, _transition|
        Reservations::ReserveMaterials.call(style_purchase_order)

        if style_purchase_order.vendor.domestic?
          VendorMailer.purchase_order(style_purchase_order).deliver_later
          style_purchase_order.update_column(:vendor_email_sent_at, Time.current)
        else
          NetsuitePurchaseOrderWorker.perform_later(style_purchase_order.id)
        end
      end

      after_transition any => :canceled do |style_purchase_order, _transition|
        style_purchase_order.reservations.enabled.find_each(&:close!)
      end

      event :submit_for_review do
        transition %i[created rejected] => :review
      end

      event :reject do
        transition review: :rejected
      end

      event :send_to_production do
        transition review: :production
      end

      event :complete do
        transition production: :completed
      end

      event :cancel do
        transition all - %i[completed canceled] => :canceled
      end
    end
  end
end
