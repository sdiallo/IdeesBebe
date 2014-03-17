# == Schema Information
#
# Table name: products
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  slug        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#  user_id     :integer
#  category_id :integer
#  active      :boolean          default(TRUE)
#  price       :integer          default(0)
#  selled      :boolean          default(FALSE)
#

FactoryGirl.define do
  factory :product do
    name 'Great product'
    description 'This is a great product'
    association :category
    price 1
    active true
    selled false
  end
end
