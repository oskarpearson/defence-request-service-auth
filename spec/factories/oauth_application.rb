FactoryGirl.define do
  factory :oauth_application, class: Doorkeeper::Application do
    sequence(:name) { |n| "application_name_#{n}" }
    #redirect_uri 'urn:ietf:wg:oauth:2.0:oob'
    redirect_uri 'https://localhost:3000/'

    trait :defence_request_service_auth  do
      name 'defence_request_service_auth'
    end

    trait :defence_request_service_rota  do
      name 'defence_request_service_rota'
    end

    trait :defence_request_service do
      name 'defence_request_service'
    end
  end
end
