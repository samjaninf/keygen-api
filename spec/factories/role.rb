# frozen_string_literal: true

FactoryBot.define do
  factory :role do
    resource { nil }

    trait :user do
      name { :user }
    end

    trait :admin do
      name { :admin }
    end

    trait :developer do
      name { :developer }
    end

    trait :sales_agent do
      name { :sales_agent }
    end

    trait :support_agent do
      name { :support_agent }
    end

    trait :product do
      name { :product }
    end

    trait :license do
      name { :license }
    end
  end
end
