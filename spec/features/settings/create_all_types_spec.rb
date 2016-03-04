require 'spec_helper'

RSpec.describe "> create all types", type: :request do  
  before :each do     
    BsAdmin::Settings.destroy_all    
    @group_1 = BsAdmin::Settings.group :group_1, "Group 1" do |m|
      @subgroup_1 = m.subgroup :subgroup_1, "Sub-Group 1" do |g|
        @string_setting  = g.string  "String Setting",  :string_setting,  "String Setting Value"
        @image_setting   = g.image   "Image Setting",   :image_setting,   "spec_test_files/image_setting_value.jpg"
        @file_setting    = g.file    "File Setting",    :file_setting,    "spec_test_files/file_setting_value.pdf"
        @text_setting    = g.text    "Text Setting",    :text_setting,    "Text Setting Value"
        @boolean_setting = g.boolean "Boolean Setting", :boolean_setting, true
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