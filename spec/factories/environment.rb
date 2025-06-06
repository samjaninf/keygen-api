# frozen_string_literal: true

FactoryBot.define do
  factory :environment do
    # Prevent duplicates due to recurring environment codes. Attempting
    # to insert duplicate codes would fail, and this prevents that.
    initialize_with { Environment.find_by(account:, code:) || new(**attributes.reject { NIL_ACCOUNT == _2 }) }

    account { NIL_ACCOUNT }

    isolation_strategy { 'ISOLATED' }
    code               { SecureRandom.hex(4) }
    name               { code.humanize }

    trait :isolated do
      isolation_strategy { 'ISOLATED' }
      code               { 'isolated' }
    end

    trait :shared do
      isolation_strategy { 'SHARED' }
      code               { 'shared' }
    end
  end
end
