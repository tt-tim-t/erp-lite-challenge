# Request-scoped attributes. Set by Api::BaseController for every request.
class Current < ActiveSupport::CurrentAttributes
  attribute :user
end
