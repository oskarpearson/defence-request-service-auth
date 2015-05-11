require "rails_helper"

RSpec.describe "GET /api/v1/profiles/search?q={query}" do
  it_behaves_like "a protected endpoint", "/api/v1/profiles/search"

  context "with a valid authentication token" do
    include_context "logged in API User"

    context "with the query parameter" do
      let(:organisation) { create :organisation }
      let!(:profile1) { create :profile, name: "Eamonn Holmes", organisations: [organisation] }
      let!(:profile2) { create :profile, name: "Barry Evans", organisations: [organisation] }
      let!(:profile3) { create :profile, name: "Sherlock Holmes", organisations: [organisation] }

      context "with profiles matching by name" do
        it "returns 200 response with matching profiles" do
          get "/api/v1/profiles/search?q=holmes", nil, api_request_headers

          expect(response.status).to eq(200)
          expect(response_json).to eq(
              "profiles" => [
                {
                  "uid" => profile1.uid,
                  "name" => profile1.name,
                  "links" => {
                    "organisation" => "/api/v1/organisations/#{organisation.uid}"
                  }
                },
                {
                  "uid" => profile3.uid,
                  "name" => profile3.name,
                  "links" => {
                    "organisation" => "/api/v1/organisations/#{organisation.uid}"
                  }
                }
              ]
            )

        end
      end
      context "when no profiles match by name" do
        it "returns 200 response with empty response" do
          get "/api/v1/profiles/search?q=foo", nil, api_request_headers

          expect(response.status).to eql(200)
          expect(response_json).to eql(
              "profiles" => []
            )
        end
      end
    end

    context "with missing query parameter" do
      it "returns 400 response" do
        get "/api/v1/profiles/search", nil, api_request_headers

        expect(response.status).to eql(400)
      end
    end
  end
end
