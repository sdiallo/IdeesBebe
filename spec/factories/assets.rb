# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :asset do
    asset "MyString"
    referencer_id nil
    referencer_type nil
    starred false

    trait :starred do
      starred true
    end
  end
end
