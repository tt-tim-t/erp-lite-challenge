# Writes an event_logs row whenever the model's state attribute changes.
# Runs after commit, so a rolled-back transition leaves no log behind.
module EventLoggable
  extend ActiveSupport::Concern

  included do
    class_attribute :logged_state_attribute, default: :state

    has_many :event_logs, as: :event_source, dependent: :destroy

    after_commit :log_state_change, on: :update, if: :state_attribute_changed?
  end

  private

  def state_attribute_changed?
    saved_change_to_attribute?(logged_state_attribute)
  end

  def log_state_change
    from, to = saved_change_to_attribute(logged_state_attribute)
    event_logs.create!(
      event: "#{logged_state_attribute}_changed",
      user: Current.user,
      details: { from:, to: }
    )
  end
end
