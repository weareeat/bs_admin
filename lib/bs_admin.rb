require "bs_admin/engine"
require "bs_admin/meta"
require "bs_admin/meta_builder"
require "bs_admin/config_builder"

module BsAdmin
  def self.dashboard?
    @@config.use_dashboard
  end

  def self.find base_path      
    self.metas.find{ |m| m.base_path == base_path }
  end

  def self.metas
    self.classes.map{ |m| m.meta }
  end

  def self.classes
    self.classes_as_string.map{ |m| m.constantize }
  end

  def self.classes_as_string
    @@config.classes.map{ |m| m }
  end

  def self.config &block
    @@config = ConfigBuilder.new
    yield(@@config)
  end
end
