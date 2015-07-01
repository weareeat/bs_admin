class BsAdminLoggedControllerBase < BsAdminControllerBase
  before_filter :require_login
end
