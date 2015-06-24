module BsAdmin::BsAdminSettingsHelper
  def setting group_key, key
    BsAdminSettings.setting(group_key, key)
  end

  def image_setting group_key, key, format=nil
    BsAdminSettings.image(group_key, key, format)
  end
end
