# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :status do
    product nil
    user nil
    closed false
    done false
  end
end
