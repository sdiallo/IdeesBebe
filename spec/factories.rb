FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end

  sequence :short_lorem do |n|
    "lorem#{n}"
  end

  sequence :nb

end