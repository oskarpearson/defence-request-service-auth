class CredentialsSerializer
  def initialize(user, gov_app)
    @user = user
    @gov_app = gov_app
  end

  def call
    serialize_credentials
  end

  private

  attr_reader :user, :gov_app

  def serialize_credentials
    credentials = {
      user: serialized_user,
      permissions: serialized_permissions,
    }
    credentials.store(:profile, serialized_profile) if user.profile
    credentials.to_json
  end

  def serialized_user
    {
      id: user.id,
      email: user.email,
      uid: user.uid,
    }
  end

  def serialized_profile
    {
      email: profile.email,
      name:  profile.name,
      telephone: profile.tel,
      address: {
        full_address: profile.address,
        postcode: profile.postcode,
      },
      organisation_ids: profile.organisations.pluck(:id)
    }
  end

  def serialized_roles
    user.roles.pluck(:name)
  end

  def serialized_permissions
    user.permissions.map { |p| serialized_permission p }
  end

  def serialized_permission(permission)
    {
      organisation_id: permission.organisation_id,
      role: permission.role.name
    }
  end

  def profile
    user.profile || NullProfile.new
  end
end
