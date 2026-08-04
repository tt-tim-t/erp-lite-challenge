# Base class for service objects. Call with `SomeService.call(args)`.
class ApplicationService
  def self.call(...)
    new(...).call
  end
end
