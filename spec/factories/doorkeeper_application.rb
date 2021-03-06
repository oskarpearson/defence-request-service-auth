FactoryGirl.define do
  factory :doorkeeper_application, class: "Doorkeeper::Application" do |application|
    name "drs-auth"
    sequence(:uid) {|i| "#{i}" }
    sequence(:secret) {|i| "#{i}" }
    redirect_uri "https://example.com/oauth/callbacks"
  end
end
