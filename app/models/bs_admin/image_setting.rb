# -*- encoding : utf-8 -*-
class BsAdmin::ImageSetting < BsAdmin::StringSetting
  mount_uploader :value, BsAdmin::ImageSettingUploader  
end
