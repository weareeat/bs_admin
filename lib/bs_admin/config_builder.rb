module BsAdmin
  class ConfigBuilder
    attr_accessor :classes, :auto_populate_classes, :use_dashboard

    def initialize
      @use_dashboard = false
    end

    def create_admin_for classes
      @classes = classes  
    end

    def auto_populate classes
      @auto_populate_classes = classes
    end

    def use_dashboard!
      @use_dashboard = true
    end
  end 
end

