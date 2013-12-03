FactoryGirl.define do
  factory :product do
    name 'Great product'
    description 'This is a great product'
    association :category
  end
end