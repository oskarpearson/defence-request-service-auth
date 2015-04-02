module Api::V1
  class CredentialsController < ApiController
    before_action :doorkeeper_authorize!
    respond_to :json

    def show
      render json: CredentialsSerializer.new(current_resource_owner, current_resource_application).call
    end
  end
end
