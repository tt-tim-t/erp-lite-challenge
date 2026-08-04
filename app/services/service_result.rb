# Lightweight result for services that can fail for business reasons.
ServiceResult = Struct.new(:success, :errors, keyword_init: true) do
  def self.success
    new(success: true, errors: [])
  end

  def self.failure(*errors)
    new(success: false, errors: errors.flatten)
  end

  def success?
    success
  end
end
