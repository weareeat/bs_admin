# -*- encoding : utf-8 -*-
class BsAdmin::SettingGroup < ActiveRecord::Base
  attr_accessible :display_name, :key, :hint
  has_many :subgroups, class_name: "BsAdmin::SettingSubGroup", dependent: :destroy
  accepts_nested_attributes_for :subgroups, allow_destroy: true

  validates_uniqueness_of :key
  
  def as_json(options=nil)    
    options = { except: [:created_at, :updated_at] }.merge options
    super(options)
  end
end
