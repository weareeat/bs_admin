module BsAdmin::Settings
  module Builder
    class Group
      attr_accessor :group

      def initialize group=nil
        @group = group if group
      end
      
      def create_group key, display_name, options
        options = {} unless options
        @group = BsAdmin::SettingGroup.create! options.merge({ key: key, display_name: display_name })
      end

      def subgroup key, display_name, options=nil, &block        
        builder = BsAdmin::Settings::Builder::SubGroup.new
        builder.create_subgroup key, display_name, options, @group
        yield builder
        builder.subgroup
      end

      def hint input
        @group.hint = input
        @group.save
      end 
    end

    class SubGroup
      attr_accessor :subgroup

      def initialize subgroup=nil
        @subgroup = subgroup if subgroup
      end

      def create_subgroup key, display_name, options, group
        options = {} unless options
        @subgroup = group.subgroups.create! options.merge({ key: key, display_name: display_name })
      end

      def hint input
        @subgroup.hint = input
        @subgroup.save
      end    

      BsAdmin::SettingSubGroup.types.each do |type|
        define_method type do |*args|
          display_name, key, value, params = args
          default_params = { display_name: display_name, key: key, value: value }
          default_params = default_params.merge(params) if params
          @subgroup.create_setting(type, default_params)
        end
      end
    end
  end
end

