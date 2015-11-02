module BsAdmin::SettingsHelper  
  def setting group_key, key
    BsAdmin::Settings.setting(group_key, key)
  end

  def image_setting group_key, key, format=nil
    BsAdmin::Settings.image(group_key, key, format)
  end
end
