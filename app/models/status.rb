class Status < ActiveRecord::Base
  belongs_to :product
  belongs_to :user
  has_many :messages

end
