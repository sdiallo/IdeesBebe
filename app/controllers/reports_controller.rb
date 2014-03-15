class ReportsController < ApplicationController

  load_and_authorize_resource :report
  load_resource :product

  def create
    current_user.reports.create!(product_id: @product.id)
    redirect_to product_path(@product.slug)
  end
end
