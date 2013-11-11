class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_uniqueness_of :username, :email
  validates :username, length: { minimum: 2 }
  
  has_one :profile, :dependent => :destroy
  has_many :products, :dependent => :destroy


  
  after_create :create_profile!

  include Slugable

  before_save :to_slug, :if => :username_changed?
end
