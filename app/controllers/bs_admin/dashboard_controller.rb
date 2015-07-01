class BsAdmin::DashboardController < BsAdminLoggedControllerBase  
  def index
    render "/admin/dashboard/index"
  end
end
