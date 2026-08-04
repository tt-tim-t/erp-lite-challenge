module Reservations
  # Reserves fabric for every active material on the SPO's active colorway
  # items. Runs when an SPO is sent to production.
  class ReserveMaterials < ApplicationService
    def initialize(style_purchase_order)
      @style_purchase_order = style_purchase_order
    end

    def call
      style_purchase_order.colorway_items.active.includes(:materials).find_each do |colorway_item|
        colorway_item.materials.select(&:active?).each do |material|
          material.reservations.create!(
            quantity: material.required_quantity,
            reserved_at: Time.current
          )
        end
      end
    end

    private

    attr_reader :style_purchase_order
  end
end
