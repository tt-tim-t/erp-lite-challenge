module Api
  # Every API controller inherits from this. It authenticates the caller,
  # enforces Pundit authorization, and renders the standard response shape:
  #
  #   { success: true, data: ..., totalCount: ... }
  #   { success: false, errors: [...] }
  class BaseController < ApplicationController
    include Pundit::Authorization

    before_action :authenticate_user!
    after_action :verify_authorized
    after_action :verify_policy_scoped, if: -> { action_name == "index" }

    rescue_from Pundit::NotAuthorizedError, with: :render_forbidden
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

    attr_reader :current_user

    private

    # Authentication is stubbed in this extract: production uses Google OAuth
    # and JWTs. Here the caller identifies itself with the X-User-Email header.
    def authenticate_user!
      @current_user = User.find_by(email: request.headers["X-User-Email"])
      return render_errors("Unauthorized", status: :unauthorized) unless @current_user

      Current.user = @current_user
    end

    def render_success(data, status: :ok, total_count: nil)
      body = { success: true, data: }
      body[:totalCount] = total_count unless total_count.nil?
      render json: body, status:
    end

    def render_errors(errors, status: :unprocessable_content)
      render json: { success: false, errors: Array(errors) }, status:
    end

    def render_result(result, data)
      result.success? ? render_success(data) : render_errors(result.errors)
    end

    def render_forbidden
      render_errors("You are not allowed to do that", status: :forbidden)
    end

    def render_not_found
      render_errors("Not found", status: :not_found)
    end

    def page
      [params.fetch(:page, 1).to_i, 1].max
    end

    def per_page
      params.fetch(:per_page, 50).to_i.clamp(1, 200)
    end
  end
end
