# Cost sheet lifecycle for a colorway item.
#
#   draft -> cost_sheet_approved -> cost_sheet_locked
#
# Locking is final: it snapshots the unit cost, and from then on the cost
# sheet's estimates are the item's actual costs.
module ColorwayItemStateMachine
  extend ActiveSupport::Concern

  included do
    state_machine :cost_sheet_state, initial: :draft do
      before_transition any => :cost_sheet_locked do |colorway_item, _transition|
        colorway_item.unit_cost_cents = colorway_item.cost_groups.sum(:extended_value_sum_cents)
        colorway_item.cost_sheet_locked_at = Time.current
      end

      event :cost_sheet_approved do
        transition draft: :cost_sheet_approved
      end

      event :cost_sheet_locked do
        transition cost_sheet_approved: :cost_sheet_locked
      end

      # Sends an approved (not yet locked) cost sheet back for changes.
      event :reject_cost_sheet do
        transition cost_sheet_approved: :draft
      end
    end
  end
end
