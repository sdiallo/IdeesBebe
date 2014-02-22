class Status < ActiveRecord::Base
  belongs_to :product
  belongs_to :user
  has_many :messages

  after_create :reactive_product, if: [:closed_changed?]

  private

    def reactive_product
      product.update_attributes!(active: true) if not product.active
    end
end
