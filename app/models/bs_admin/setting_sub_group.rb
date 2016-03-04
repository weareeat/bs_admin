# -*- encoding : utf-8 -*-
class BsAdmin::SettingSubGroup < ActiveRecord::Base
  attr_accessible :display_name, :main_group, :key, :hint
  belongs_to :group, class_name: "BsAdmin::SettingGroup"

  validates_uniqueness_of :key, scope: :setting_group_id

  def self.types
    ["string", "image", "file", "text", "boolean"]
  end

  self.types.each do |type|
    type_plural = type.pluralize
    has_many type_plural.to_sym, class_name: "BsAdmin::#{type.capitalize}Setting", dependent: :destroy
    accepts_nested_attributes_for type_plural.to_sym, allow_destroy: true
  end

  def create_setting type, params
    raise "A Setting with the key: '#{params[:key]}' already exists in this subgroup" if find_setting_by_key params[:key]
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
      self.class.types.each { |t| result.push *self.send(t.pluralize).all }
      result
    end
  end

  def find_setting_by_key key
    settings.select{ |s| s.key.to_s == key.to_s }.first
  end

  def find_setting_by_key! key
    r = find_setting_by_key key    
    raise "Setting '#{key}' not found." unless r
    r
  end


  def as_json(options=nil)    
    options = { except: [:created_at, :updated_at, :main_group] }.merge options
    super(options)
  end
end
