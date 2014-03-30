class Admin::SessionsController < Devise::SessionsController

  def new
    raise CanCan::AccessDenied if user_signed_in? and not current_user.is_admin
    render layout: 'admin'
  end

  def after_sign_in_path_for resource
    admin_dashboard_index_path if request.path.starts_with?('/admin')    
  end
end
