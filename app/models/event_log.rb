class EventLog < ApplicationRecord
  belongs_to :event_source, polymorphic: true
  belongs_to :user, optional: true

  validates :event, presence: true
end
