# Nightly cleanup: disables reservations whose SPO has been canceled or
# completed so the fabric shows as available again.
class ReleaseStaleReservationsWorker < ApplicationJob
  queue_as :low

  def perform
    Reservation.all.each do |reservation|
      next unless reservation.enabled?

      style_purchase_order = reservation.material.colorway_item.style_purchase_order
      reservation.disable! if style_purchase_order.canceled? || style_purchase_order.completed?
    end
  end
end
