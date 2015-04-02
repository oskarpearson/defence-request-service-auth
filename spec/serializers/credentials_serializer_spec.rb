require "rails_helper"

RSpec.describe CredentialsSerializer, "#call" do

  subject { CredentialsSerializer.new(user, application).call }

  context "user has a profile" do
    let!(:profile) { create :profile }
    let!(:user) { create :user, profile: profile }
    let!(:application) { create :government_application }
    let!(:permission) { create :permission, government_application: application, user: user }

    specify do
      credentials_json = {
        user: {
          id: user.id,
          email: user.email,
          uid: user.uid
        },
        profile: {
          email: user.profile.email,
          name: user.profile.name,
          telephone: user.profile.tel,
          address: {
            full_address: user.profile.address,
            postcode: user.profile.postcode,
          },
          organisation_ids: user.profile.organisations.map(&:id)
        },
        permissions: [
          {
            organisation_id: permission.organisation_id,
            role: permission.role.name
          }
        ]
      }.to_json

      profile_json = { profile: {
        email: user.profile.email,
        name: user.profile.name,
        telephone: user.profile.tel,
        address: {
          full_address: user.profile.address,
          postcode: user.profile.postcode,
        },
        organisation_ids: user.profile.organisations.map(&:id)
      }
      }.to_json

      expect(subject).to match(a_string_including profile_json)
    end
  end

  xcontext "user has no profile" do
    let!(:user) { create :user }
    let!(:application) { create :government_application }
    let!(:permission) { create :permission, government_application: application, user: user }

    specify "returns nil" do
      credentials_json = {
        user: {
          id: user.id,
          email: user.email,
          uid: user.uid
        },
        permissions: [
          {
            organisation_id: permission.organisation_id,
            role: permission.role.name
          }
        ]
      }

      expect(subject).to eq credentials_json
    end
  end
end
