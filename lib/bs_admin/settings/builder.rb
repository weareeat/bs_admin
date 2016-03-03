module BsAdmin::Settings::Builder
  class GroupBuilder
    attr_accessible :group

    def initialize group
      @group = group
    end
    
    def initialize key, display_name, options=nil
      options = {} unless options
      options.merge({ key: key, display_name: display_name })
      @group = BsAdmin::SettingGroup.create options
    end

    def subgroup key, display_name, options=nil, &block
      options = {} unless options
      options.merge({ key: key, display_name: display_name })
      subgroup = @group.subgroups.create(options)      
      yield BsAdmin::Settings::SettingBuilder.new(subgroup)
      subgroup
    end

    def hint input
      @group.hint = input
      @group.save
    end 
  end

  class SettingBuilder
    def initialize subgroup
      @subgroup = subgroup
    end

    def hint input
      @subgroup.hint = input
      @subgroup.save
    end    

    BsAdmin::SettingSubGroup.types.each do |type|
      define_method("#{type}") do |*args|
        display_name, key, value, params = args
        default_params = { display_name: display_name, key: key, value: value }
        default_params = default_params.merge(params) if params
        @subgroup.create_setting(type, default_params)
      end
    end
  end
end

