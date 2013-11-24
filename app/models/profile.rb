class Profile < ActiveRecord::Base
  
  belongs_to :user
  has_one :asset, as: :referencer, dependent: :destroy # For avatar
  accepts_nested_attributes_for :asset, reject_if: :has_avatar?

  def has_avatar?
    self.asset.nil? ? false : true
  end

  validates :first_name, :last_name, format: { with: /\A[a-zA-Z]+\z/ }, allow_blank: true

end
