class Profile < ActiveRecord::Base
  
  belongs_to :user
  has_one :asset, as: :referencer, dependent: :destroy
  accepts_nested_attributes_for :asset, reject_if: :has_avatar?


  validates :first_name, :last_name, format: { with: /\A[a-zA-Z]+\z/, message: I18n.t('profile.first_and_last_name.format') }, allow_blank: true

  def has_avatar?
    self.asset.nil? ? false : true
  end
end
