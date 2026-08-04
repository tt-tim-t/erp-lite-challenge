class VendorMailer < ApplicationMailer
  def purchase_order(style_purchase_order)
    @style_purchase_order = style_purchase_order
    @colorway_items = style_purchase_order.colorway_items.active.includes(colorway_style: %i[style colorway])

    mail(
      to: style_purchase_order.vendor.email,
      subject: "Purchase order #{style_purchase_order.po_number}"
    )
  end
end
