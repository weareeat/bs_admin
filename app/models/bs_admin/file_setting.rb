# -*- encoding : utf-8 -*-
class BsAdmin::FileSetting < StringSetting
  mount_uploader :value, FileSettingUploader
end
