class CredentialsSerializer
  def initialize(user: , application:)
    @user, @application = user, application
  end

  def as_json(opts = {})
    serialize
  end

  def serialize
    {
      user: serialized_user
    }
  end

  private

  attr_reader :user, :application

  def serialized_user
    {
      email: user.email,
      name: user.name,
      telephone: user.telephone,
      mobile: user.mobile,
      address: {
        full_address: user.address,
        postcode: user.postcode,
      },
      organisations: serialized_organisations,
      uid: user.uid,
    }
  end

  def serialized_organisations
    user.memberships.map do |membership|
      organisation = membership.organisation

      {
          uid: organisation.uid,
          name: organisation.name,
          type: organisation.organisation_type,
          roles: membership.roles & @application.available_role_names
      }
    end
  end
end
