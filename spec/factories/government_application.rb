FactoryGirl.define do
  factory :government_application do
    association :oauth_application

    trait :gov_app_defence_request_service_auth  do
      association :oauth_application, :defence_request_service_auth
    end

    trait :gov_app_defence_request_service_rota  do
      association :oauth_application, :defence_request_service_rota
    end

    trait :gov_app_defence_request_service do
      association :oauth_application, :defence_request_service
    end
  end
end
