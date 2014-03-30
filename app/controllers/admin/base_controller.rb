class Admin::BaseController < ApplicationController

  before_filter :verify_admin, unless: :devise_controller?

  layout 'admin'

  private

    def verify_admin
      return redirect_to admin_path if not user_signed_in? 
      raise CanCan::AccessDenied unless current_user.is_admin
    end
end