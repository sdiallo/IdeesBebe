class User < ActiveRecord::Base
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :username,
    length: { minimum: 2, message: I18n.t('devise.failed.username') },
    presence: true,
    uniqueness: { :case_sensitive => false }
  validates :email, presence: { message: I18n.t('devise.failed.email') }
  
  has_one :profile, dependent: :destroy

  has_many :products, dependent: :destroy  
  has_many :comments, dependent: :destroy

  attr_accessor :login

  
  after_create :create_profile!

  include Slugable

  before_save :to_slug, :if => :username_changed?


  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def avatar
    if profile.asset and not profile.asset.id.nil?
      return profile.asset.asset
    end
    return nil
  end

  def avatar_id
    if profile.asset and not profile.asset.id.nil?
      return profile.asset.id
    end
    return nil
  end
end
