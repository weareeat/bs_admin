# -*- encoding : utf-8 -*-
class BsAdmin::SessionsController < BsAdminControllerBase
  def new
    redirect_to bs_admin.settings_group_path if admin?
  end

  def create    
    session[:admin_password] = params[:password]

    if admin?
      flash[:notice] = "Successfully logged in";
      if BsAdmin.dashboard?
        redirect_to bs_admin.dashboard_path
      else
        redirect_to bs_admin.settings_group_path
      end
    else
      flash[:error] = "Wrong password!";
      redirect_to bs_admin.root_path
    end
  end

  def destroy
    session[:admin_password] = nil
    flash[:notice] = "Successfully logged out";
    redirect_to bs_admin.root_path
  end
end
