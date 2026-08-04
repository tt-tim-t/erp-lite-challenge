require "net/http"

module Netsuite
  # Thin HTTP client for the NetSuite purchase order endpoint.
  #
  # When NETSUITE_BASE_URL is not set (every local and test environment) the
  # gateway does not make network calls; it returns a simulated id instead.
  class Gateway
    class Error < StandardError; end
    class TimeoutError < Error; end

    def initialize(base_url: ENV.fetch("NETSUITE_BASE_URL", nil), token: ENV.fetch("NETSUITE_TOKEN", "local-dev-token"))
      @base_url = base_url
      @token = token
    end

    # Creates a purchase order and returns its NetSuite internal id.
    def create_purchase_order(payload)
      return "NS-SIM-#{payload.fetch(:external_reference)}" if base_url.blank?

      response = Net::HTTP.post(
        URI.join(base_url, "/purchase_orders"),
        payload.to_json,
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{token}"
      )
      raise Error, "NetSuite responded #{response.code}" unless response.is_a?(Net::HTTPSuccess)

      JSON.parse(response.body).fetch("id")
    rescue Net::OpenTimeout, Net::ReadTimeout => e
      raise TimeoutError, e.message
    end

    private

    attr_reader :base_url, :token
  end
end
