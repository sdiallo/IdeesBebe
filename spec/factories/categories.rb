# == Schema Information
#
# Table name: categories
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  slug             :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  main_category_id :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category do
    name 'CatégorieExAmple'
    slug "si-si"
    main_category_id nil
  end
end
