# == Schema Information
#
# Table name: reports
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  product_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Report < ActiveRecord::Base
  belongs_to :user
  belongs_to :product

  LIMIT_BEFORE_ADMIN_CHECK = 3

  after_create :product_need_check, if: :reach_the_limit?

  private
    def reach_the_limit?
      product.reports.count >= LIMIT_BEFORE_ADMIN_CHECK
    end

    def product_need_check
      product.disallowed!
      Notifier.delay.admin_need_to_check(product)
    end
end
