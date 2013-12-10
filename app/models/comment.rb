class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :product

  validates :content, 
    length: { maximum: 140 },
    presence: true
end
