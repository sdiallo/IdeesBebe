class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?
  
  protected

  def configure_permitted_parameters
  	devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:username, :email, :password) }
  	devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation) }
  end

  #TODO:: IMPROVE! and test
  def must_be_current_user
    if @user != current_user
      if params[:controller] == 'products'
        redirect_to product_path(@product.slug), notice: "Vous ne pouvez pas altérer le produit d'un autre utilisateur" 
      else
        redirect_to profile_path(@user.slug), notice: "Vous ne pouvez pas altérer le profil d'un autre utilisateur" 
      end
    end
  end
end
