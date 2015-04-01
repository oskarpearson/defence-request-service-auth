FactoryGirl.define do
  factory :permission do
    association :government_application
    association :role
    association :organisation
    association :user

    trait :with_gov_app_defence_request_service_auth do
      association :government_application, :gov_app_defence_request_service_auth
    end

    trait :with_gov_app_defence_request_service_rota do
      association :government_application, :gov_app_defence_request_service_auth
    end

    trait :with_gov_app_defence_request_service do
      association :government_application, :gov_app_defence_request_service_auth
    end
  end
end
