# -*- encoding : utf-8 -*-
class BsAdmin::SettingGroup < ActiveRecord::Base
  attr_accessible :display_name, :main_group, :key

  def self.types
    ["string", "image", "file", "text", "boolean"]
  end

  self.types.each do |type|
    type_plural = type.pluralize
    has_many type_plural.to_sym, class_name: "BsAdmin::#{type.capitalize}Setting", dependent: :destroy
    accepts_nested_attributes_for type_plural.to_sym, allow_destroy: true
  end

  def create_setting type, params
    if ["image", "file"].include?(type) and params[:value]
      params[:value] = File.open(File.join(Rails.root, "/db/seed-files/" + params[:value]))
    end

    type_plural = type.pluralize

    s = self.send(type_plural).find_by_key(params[:key])
    if s
      s.update_attributes(params) if !s.has_user_changed
    else
      s = self.send(type_plural).create params
    end
  end

  def settings type=nil
    if type
      self.send(type.pluralize)
    else
      result = []
      self.types.each { |t| result << self.send(t.pluralize).all }
      result
    end
  end

  def self.find_group group_key
    g = BsAdmin::SettingGroup.find_by_key(group_key)
    raise "SettingGroup '#{group_key}' not found" unless g
    g
  end
end
