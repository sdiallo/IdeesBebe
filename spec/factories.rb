FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end

  sequence :username do |n|
    "example_username#{n}"
  end

  sequence :name do |n|
    "example_name#{n}"
  end
end
