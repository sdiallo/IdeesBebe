class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :product

  validates :content, length: { minimum: 1, maximum: 140 }
end
