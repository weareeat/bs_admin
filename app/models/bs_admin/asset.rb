class BsAdmin::Asset < ActiveRecord::Base
  attr_accessible :file, :group, :type
  mount_uploader :file, BsAdmin::AssetUploader
end
