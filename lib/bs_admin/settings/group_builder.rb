require "bs_admin/settings/setting_builder"

class BsAdmin::Settings
  class GroupBuilder
    def initialize main_group
      @main_group = main_group
    end

    def group key, display_name, &block
      group = BsAdmin::SettingGroup.new key: key
      group.update_attributes(main_group: @main_group, key: key, display_name: display_name)
      yield BsAdmin::Settings::SettingBuilder.new(group)
    end
  end
end
