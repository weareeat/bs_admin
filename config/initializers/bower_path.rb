debugger
Rails.application.config.assets.paths << Rails.root.join(Gem.loaded_specs['bs_admin'].full_gem_path, 'vendor', 'bower_components')