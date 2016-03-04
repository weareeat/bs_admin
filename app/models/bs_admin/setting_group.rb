# -*- encoding : utf-8 -*-
class BsAdmin::SettingGroup < ActiveRecord::Base
  attr_accessible :display_name, :key, :hint
  has_many :subgroups, class_name: "BsAdmin::SettingSubGroup", dependent: :destroy
  accepts_nested_attributes_for :subgroups, allow_destroy: true

  validates_uniqueness_of :key

  def self.find_group group_key
    g = BsAdmin::SettingGroup.find_by_key(group_key)
    raise "SettingGroup '#{group_key}' not found" unless g
    g
  end
end
