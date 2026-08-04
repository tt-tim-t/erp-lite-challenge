# Creates the NetSuite purchase order for an overseas SPO once it is sent to
# production, then stamps the SPO and its costs.
class NetsuitePurchaseOrderWorker < ApplicationJob
  queue_as :netsuite

  retry_on Netsuite::Gateway::TimeoutError, wait: :polynomially_longer, attempts: 5

  def perform(style_purchase_order_id)
    style_purchase_order = StylePurchaseOrder.find(style_purchase_order_id)
    payload = Netsuite::PurchaseOrderPayload.new(style_purchase_order).to_h

    netsuite_id = Netsuite::Gateway.new.create_purchase_order(payload)

    style_purchase_order.update!(netsuite_id:)
    style_purchase_order.costs.update_all(po_triggered_at: Time.current)
  end
end
