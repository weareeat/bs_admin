# -*- encoding : utf-8 -*-
class BsAdmin::FileSetting < BsAdmin::StringSetting
  mount_uploader :value, BsAdmin::FileSettingUploader
end
