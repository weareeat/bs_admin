# -*- encoding : utf-8 -*-
class BsAdmin::BooleanSetting < ActiveRecord::Base
  attr_accessible :display_name, :hint, :key, :value, :user_has_changed
  belongs_to :group, class_name: "BsAdmin::SettingSubGroup", :foreign_key => :setting_sub_group_id
  validates_uniqueness_of :key, scope: :setting_sub_group_id

  def as_json(options=nil)    
    options = { except: [:created_at, :updated_at, :has_user_changed], methods: [:field_type] }.merge options
    super(options)
  end

  def field_type
    "boolean"
  end
end
