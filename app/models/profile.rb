class Profile < ActiveRecord::Base
  
  belongs_to :user

  mount_uploader :avatar, AvatarUploader

  validates :first_name, :last_name, format: { with: /\A[a-zA-Z]+\z/ }, allow_blank: true

end
