require "bs_admin/settings/group_builder"

module BsAdmin::Settings
  def self.create name, &block
    yield BsAdmin::Settings::GroupBuilder.new(name)
  end

  def self.setting group_key, key
    group = BsAdmin::SettingGroup.find_group group_key
    setting = nil
    if group
      ["strings", "files", "texts", "booleans"].each do |t|
        setting = group.send(t).find_by_key(key)
        break if setting
      end

      if setting
        setting.value
      else        
        raise "Setting '#{key}' not found in '#{group_key}' SettingGroup."
      end
    end
  end

  def self.image group_key, key, format=nil
    group = BsAdmin::SettingGroup.find_group group_key
    if group
      setting = group.images.find_by_key(key)
      if setting
        format ? f.value_url(format) : setting.value_url
      else
        raise "ImageSetting '#{key}' not found in '#{group_key}' SettingGroup."
      end
    end
  end

  def self.destroy_all
    BsAdmin::StringSetting.destroy_all
    BsAdmin::BooleanSetting.destroy_all
    BsAdmin::TextSetting.destroy_all
    BsAdmin::SettingGroup.destroy_all
  end

  def self.destroy main_group
    BsAdmin::SettingGroup.where("main_group = ?", main_group).each{ |g| g.destroy }
  end

  def self.destroy_group group_key
    BsAdmin::SettingGroup.find_by_key(group_key).destroy
  end

  def self.destroy_setting group_key, setting_key
    BsAdmin::SettingGroup.find_group(group_key).settings.each do |s|
      s.destroy if s.key == setting_key
    end
  end

  def self.add_to_group key, &block
    group = BsAdmin::SettingGroup.find_by_key key
    yield BsAdmin::SettingBuilder.new(group)
  end
end
