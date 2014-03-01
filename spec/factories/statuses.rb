# == Schema Information
#
# Table name: statuses
#
#  id         :integer          not null, primary key
#  product_id :integer
#  user_id    :integer
#  closed     :boolean
#  done       :boolean
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :status do
    product nil
    user nil
    closed false
    done false
  end
end
