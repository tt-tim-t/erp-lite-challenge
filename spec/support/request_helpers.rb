module RequestHelpers
  def auth_headers(user)
    { "X-User-Email" => user.email }
  end

  def json_body
    JSON.parse(response.body)
  end
end

RSpec.configure do |config|
  config.include RequestHelpers, type: :request
end
