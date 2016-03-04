# -*- encoding : utf-8 -*-
class BsAdmin::StringSetting < ActiveRecord::Base
  attr_accessible :display_name, :hint, :key, :value, :user_has_changed
  belongs_to :group, class_name: "BsAdmin::SettingSubGroup", :foreign_key => :setting_sub_group_id
  validates_uniqueness_of :key, scope: :setting_sub_group_id
end
