require "bs_admin/settings/builder"

module BsAdmin::Settings
  def self.create_group group_key, display_name, options=nil, &block
    builder = BsAdmin::Settings::Builder::Group.new
    builder.create_group group_key, display_name, options
    yield builder if block_given?
    builder.group
  end

  def self.add_to_group group_key, &block
    match = group group_key
    yield BsAdmin::Settings::Builder::Group.new match
    match
  end

  def self.add_to_subgroup group_key, subgroup_key, &block
    match = subgroup group_key, subgroup_key
    yield BsAdmin::Settings::Builder::SubGroup.new match  
    match
  end

  def self.setting group_key, subgroup_key, key
    match = subgroup group_key, subgroup_key

    setting = nil
    if match
      ["strings", "files", "texts", "booleans"].each do |t|
        setting = match.send(t).find_by_key(key)
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
    match = subgroup group_key, subgroup_key

    if match
      setting = match.images.find_by_key(key)
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
    BsAdmin::ImageSetting.destroy_all
    BsAdmin::FileSetting.destroy_all
    BsAdmin::SettingGroup.destroy_all
    BsAdmin::SettingSubGroup.destroy_all
  end

  def self.destroy_group group_key
    match = group group_key
    match.destroy
  end

  def self.destroy_subgroup group_key, subgroup_key
    match = subgroup group_key, subgroup_key
    match.destroy
  end

  def self.destroy_setting group_key, subgroup_key, key
    match = subgroup group_key, subgroup_key    
    setting = match.find_setting_by_key(key)
    raise "Setting '#{group_key}>#{subgroup_key}>#{key}' not found." unless setting
    setting.destroy
  end  

  def self.group group_key    
    match = BsAdmin::SettingGroup.find_by_key group_key
    raise "SettingGroup '#{group_key}' not found." unless match
    match
  end

  def self.subgroup group_key, subgroup_key    
    group_match = group group_key
    subgroup_match = group_match.subgroups.find_by_key(subgroup_key)
    raise "SettingSubGroup '#{group_key}>#{subgroup_key}' not found." unless subgroup_match
    subgroup_match
  end
end
