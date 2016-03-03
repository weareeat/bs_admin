require "bs_admin/settings/builder"

module BsAdmin::Settings
  def self.create group_key, display_name, options=nil, &block
    builder = BsAdmin::Settings::GroupBuilder.new(group_key, display_name, options)
    yield builder
    builder.group
  end

  def self.add_to_group group_key, &block
    group = get_group group_key
    yield BsAdmin::Settings::GroupBuilder.new(group)
  end

  def self.setting group_key, subgroup_key, key
    subgroup = get_subgroup group_key, subgroup_key

    setting = nil
    if subgroup
      ["strings", "files", "texts", "booleans"].each do |t|
        setting = subgroup.send(t).find_by_key(key)
        break if setting
      end

      if setting
        setting.value
      else
        raise "Setting '#{group_key}>#{subgroup_key}>#{key}' not found."
      end
    end
  end

  def self.image_setting group_key, subgroup_key, key, format=nil    
    subgroup = get_subgroup group_key, subgroup_key

    if subgroup
      setting = subgroup.images.find_by_key(key)
      if setting
        format ? f.value_url(format) : setting.value_url
      else        
        raise "ImageSetting '#{group_key}>#{subgroup_key}>#{key}' not found."
      end
    end
  end

  def self.destroy_all
    BsAdmin::StringSetting.destroy_all
    BsAdmin::BooleanSetting.destroy_all
    BsAdmin::TextSetting.destroy_all
    BsAdmin::SettingGroup.destroy_all
  end

  def self.destroy_group group_key
    group = get_group group_key
    group.destroy
  end

  def self.destroy_group group_key, subgroup_key
    subgroup = get_subgroup group_key, subgroup_key
    subgroup.destroy
  end

  def self.destroy_setting group_key, subgroup_key, key
    subgroup = get_subgroup group_key, subgroup_key
    setting = subgroup.settings.find_by_key(key)
    raise "Setting '#{group_key}>#{subgroup_key}>#{key}' not found." unless setting
    setting.destroy
  end  

  private

  def self.get_group group_key
    group = BsAdmin::SettingGroup.find_by_key group_key
    raise "SettingGroup '#{group_key}' not found." unless group
  end

  def self.get_subgroup group_key, subgroup_key    
    group = get_group group_key
    subgroup = group.subgroups.find_by_key(subgroup_key)
    raise "SettingSubGroup '#{group_key}>#{subgroup_key}' not found." unless subgroup
    subgroup
  end
end
