FactoryGirl.define do
  sequence :email_example do |n|
    "person#{n}@example.com"
  end

  sequence :username_example do |n|
    "username#{n}"
  end

  sequence :name_example do |n|
    "example_name#{n}"
  end
end
