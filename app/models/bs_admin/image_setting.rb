# -*- encoding : utf-8 -*-
class BsAdmin::ImageSetting < BsAdmin::StringSetting
  mount_uploader :value, BsAdmin::ImageSettingUploader  

  def field_type  
    "image"    
  end
end
