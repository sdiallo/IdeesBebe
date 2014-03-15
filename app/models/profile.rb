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
#  avatar     :string(255)
#

class Profile < ActiveRecord::Base
  
  belongs_to :user

  mount_uploader :avatar, PhotoUploader

  validates :first_name, :last_name, format: { with: /\A[a-zA-Z]+\z/ }, allow_blank: true

end
