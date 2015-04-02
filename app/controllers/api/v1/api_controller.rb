module Api::V1
  class ApiController < ApplicationController
    protect_from_forgery with: :null_session
    skip_before_action :authenticate_user!
    before_action :doorkeeper_authorize!

    private

    def current_resource_owner
      User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end

    def current_resource_application
      GovernmentApplication.find_by(oauth_application_id: doorkeeper_token.application.id) if doorkeeper_token
    end

    def doorkeeper_unauthorized_render_options
      {
        json: {
          errors: ["Not authorized, please login"]
        }
      }
    end
  end
end
