FactoryBot.define do
  factory :event do
    title { Faker::StarWars.planet }
    description { Faker::Hipster.paragraph(2) }
    address "MyString"
    person "Mrs. Doe, tel: 012345678"
    lat 1.5
    lng 1.5

    trait :published do
      published_at { Time.now }
    end

    trait :with_shift do
      after :build do |event, evaluator|
        event.shifts << FactoryBot.build(:shift, event: nil)
      end
    end

    trait :with_past_shift do
      after :build do |event, evaluator|
        event.shifts << build(:shift, :past, event: nil)
      end
    end

    trait :with_full_shift do
      after :build do |event, evaluator|
        event.shifts << build(:shift, :full, event: nil)
      end
    end

    trait :skip_validate do
      to_create {|instance| instance.save(validate: false) }
    end
  end
end
