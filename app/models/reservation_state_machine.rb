module ReservationStateMachine
  extend ActiveSupport::Concern

  included do
    state_machine :state, initial: :enabled do
      event :disable do
        transition enabled: :disabled
      end

      event :enable do
        transition disabled: :enabled
      end

      event :close do
        transition %i[enabled disabled] => :closed
      end
    end
  end
end
