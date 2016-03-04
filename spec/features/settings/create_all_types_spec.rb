require 'spec_helper'

RSpec.describe "> create all types", type: :request do  
  before :each do     
    BsAdmin::Settings.destroy_all    
    @group_1 = BsAdmin::Settings.create_group :group_1, "Group 1" do |g|
      @subgroup_1 = g.create_subgroup :subgroup_1, "Sub-Group 1" do |s|
        @string_setting  = s.string  :string_setting,  "String Setting", "String Setting Value"
        @image_setting   = s.image   :image_setting,   "Image Setting",  "spec_test_files/image_setting_value.jpg"
        @file_setting    = s.file    :file_setting,    "File Setting",   "spec_test_files/file_setting_value.pdf"
        @text_setting    = s.text    :text_setting,    "Text Setting",   "Text Setting Value"
        @boolean_setting = s.boolean :boolean_setting, "Boolean Setting", true
      end      
    end
  end   

  it "> check string value" do
    actual = BsAdmin::Settings.setting :group_1, :subgroup_1, :string_setting
    expect(actual).to eq @string_setting.value
  end

  it "> check image value" do
    actual = BsAdmin::Settings.image_setting :group_1, :subgroup_1, :image_setting
    expect(actual.to_s).to eq @image_setting.value.to_s
  end

  it "> check file value" do
    actual = BsAdmin::Settings.setting :group_1, :subgroup_1, :file_setting
    expect(actual.to_s).to eq @file_setting.value.to_s
  end

  it "> check text value" do
    actual = BsAdmin::Settings.setting :group_1, :subgroup_1, :text_setting
    expect(actual).to eq @text_setting.value
  end

  it "> check boolean value" do
    actual = BsAdmin::Settings.setting :group_1, :subgroup_1, :boolean_setting
    expect(actual).to eq @boolean_setting.value
  end
end