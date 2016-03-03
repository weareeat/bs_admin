module BsAdmin
  class Engine < ::Rails::Engine
    isolate_namespace BsAdmin
    config.generators do |g|
      g.test_framework :rspec      
    end
  end
end
