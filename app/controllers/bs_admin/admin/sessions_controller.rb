# -*- encoding : utf-8 -*-
class BsAdmin::Admin::SessionsController < BsAdminControllerBase
  layout 'admin'
  def new
    redirect_to bs_admin.admin_settings_group_path if admin?
  end

  def create
    session[:password] = params[:password]

    if admin?
      flash[:notice] = "Successfully logged in";
      if BS_ADMIN_DASHBOARD
        redirect_to bs_admin.admin_dashboard_path
      else
        redirect_to bs_admin.admin_settings_group_path
      end
    else
      flash[:error] = "Wrong password!";
      redirect_to bs_admin.admin_root_path
    end
  end

  def destroy
    reset_session
    flash[:notice] = "Successfully logged out";
    redirect_to bs_admin.admin_root_path
  end
end
