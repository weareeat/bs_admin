# -*- encoding : utf-8 -*-
class BsAdminControllerBase < ActionController::Base
  layout 'bs_admin'
  helper BsAdmin::SettingsHelper
  helper BsAdmin::ViewHelper

  before_filter :initialize_common

  protected  
  
  def require_login
    unless admin?
      flash[:error] = "You must be logged in to access this section"
      redirect_to bs_admin.login_path
    end
  end

  private

  def initialize_common
    @action = action_name
  end

  def admin?
    session[:admin_password] == ENV["ADMIN_PASSWORD"]
  end
  helper_method :admin?
end
