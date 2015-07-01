require "bs_admin/engine"
require "bs_admin/meta"
require "bs_admin/meta_builder"

module BsAdmin
  def self.dashboard?
    BS_ADMIN_DASHBOARD
  end

  def self.find base_path      
    all.find{ |m| m.base_path == base_path }
  end

  def self.all      
    BS_ADMIN.map{ |m| m.constantize.meta }
  end
end
