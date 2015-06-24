# -*- encoding : utf-8 -*-
class BsAdmin::ImageSetting < StringSetting
  mount_uploader :value, ImageSettingUploader
end
