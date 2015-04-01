class Api::V1::UsersController < Api::V1::BaseController
  before_action :doorkeeper_authorize!
  respond_to    :json

  # GET /me.json
  def me
binding.pry
    permissions = current_resource_owner.permissions
    app = GovernmentApplication.find_by(oauth_application_id: doorkeeper_token.application.id)
    the_stuff = {user: current_resource_owner, permissions: permissions}
    respond_with the_stuff

    # respond_with current_resource_owner.roles
  end

  private

  # Find the user that owns the access token
  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
