# == Schema Information
#
# Table name: profiles
#
#  id         :integer          not null, primary key
#  first_name :string(255)
#  last_name  :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_profiles_on_user_id  (user_id)
#

class Profile < ActiveRecord::Base
  
  belongs_to :user
  has_one :asset, as: :referencer, dependent: :destroy
  accepts_nested_attributes_for :asset, reject_if: :has_avatar?


  validates :first_name, :last_name, format: { with: /\A[a-zA-Z]+\z/, message: I18n.t('profile.first_and_last_name.format') }, allow_blank: true

  def has_avatar?
    asset.present?
  end
end
