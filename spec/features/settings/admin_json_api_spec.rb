require 'spec_helper'

RSpec.describe "> admin_json_api", type: :request do  
  before :each do     
    @base_url = "/admin/bs_admin_api/settings"

    BsAdmin::Settings.destroy_all
    @group_1 = BsAdmin::Settings.create_group :group_1, "Group 1" do |g|
      @subgroup_1 = g.create_subgroup :subgroup_1, "Sub-Group 1" do |s|
        @subgroup_1_test_setting_1 = s.string :test_setting_1, "Test Setting 1", "Test Value 1"
        @subgroup_1_test_setting_2 = s.string :test_setting_2, "Test Setting 2", "Test Value 2"
      end
      @subgroup_2 = g.create_subgroup :subgroup_2, "Sub-Group 2" do |s|
        @subgroup_2_test_setting_1 = s.string :test_setting_1, "Test Setting 1", "Test Value 1"
        @subgroup_2_test_setting_2 = s.string :test_setting_2, "Test Setting 2", "Test Value 2"
      end
    end
    
    @group_2 = BsAdmin::Settings.create_group :group_2, "Group 2" do |g|
      @subgroup_3 = g.create_subgroup :subgroup_3, "Sub-Group 3" do |s|
        @subgroup_3_test_setting_1 = s.string :test_setting_1, "Test Setting 1", "Test Value 1"
        @subgroup_3_test_setting_2 = s.string :test_setting_2, "Test Setting 2", "Test Value 2"
      end
      @subgroup_4 = g.create_subgroup :subgroup_4, "Sub-Group 4" do |s|
        @subgroup_4_test_setting_1 = s.string :test_setting_1, "Test Setting 1", "Test Value 1"
        @subgroup_4_test_setting_2 = s.string :test_setting_2, "Test Setting 2", "Test Value 2"
      end
    end    
  end       

  it "> groups" do    
    get @base_url
    expect(response).to be_success
    parsed = json_response_array
    expect(parsed.count).to eq 2
    parsed.each{ |i| expect(i).to match_model_schema :settings_group }    
    expect(parsed[0]['key']).to eq @group_1.key.to_s
    expect(parsed[1]['key']).to eq @group_2.key.to_s
  end

  it "> subgroups" do       
    get "#{@base_url}/#{@group_1.key}"
    expect(response).to be_success
    parsed = json_response_array
    expect(parsed.count).to eq 2    
    parsed.each{ |i| expect(i).to match_model_schema :settings_subgroup }
    expect(parsed[0]['key']).to eq @subgroup_1.key.to_s
    expect(parsed[1]['key']).to eq @subgroup_2.key.to_s
  end

  it "> settings" do    
    get "#{@base_url}/#{@group_1.key}/#{@subgroup_1.key}"
    expect(response).to be_success
    parsed = json_response_array
    expect(parsed.count).to eq 2
    parsed.each{ |i| expect(i).to match_model_schema :settings_setting }
    expect(parsed[0]['key']).to eq @subgroup_1_test_setting_1.key.to_s
    expect(parsed[1]['key']).to eq @subgroup_1_test_setting_2.key.to_s
  end

  it "> show" do
    @group_3 = BsAdmin::Settings.create_group :group_3, "Group 3" do |g|
      @subgroup_1 = g.create_subgroup :subgroup_1, "Sub-Group 1" do |s|
        @string_setting  = s.string  :string_setting,  "String Setting", "String Setting Value"
        @image_setting   = s.image   :image_setting,   "Image Setting",  "spec_test_files/image_setting_value.jpg"
        @file_setting    = s.file    :file_setting,    "File Setting",   "spec_test_files/file_setting_value.pdf"
        @text_setting    = s.text    :text_setting,    "Text Setting",   "Text Setting Value"
        @boolean_setting = s.boolean :boolean_setting, "Boolean Setting", true
      end      
    end

    data = [
      { object: @string_setting, expect_type: "string" },
      { object: @image_setting, expect_type: "image" },
      { object: @file_setting, expect_type: "file" },
      { object: @text_setting, expect_type: "text" },
      { object: @boolean_setting, expect_type: "boolean" }
    ]

    data.each do |i|
      get "#{@base_url}/#{@group_3.key}/#{@subgroup_1.key}/#{i[:object].key}"
      expect(response).to be_success
      expect(json_response).to match_model_schema :settings_setting
      expect(json_response[:field_type]).to eq i[:expect_type]
      expect(json_response[:key]).to eq i[:object].key.to_s
    end
  end

  it "> update" do
    test_value = "Test Value A"
    put "#{@base_url}/#{@group_1.key}/#{@subgroup_1.key}/#{@subgroup_1_test_setting_1.key}", { setting: { value: test_value } }
    expect(response).to json_success_schema :settings_setting
    
    value_from_rb = BsAdmin::Settings.setting @group_1.key, @subgroup_1.key, @subgroup_1_test_setting_1.key
    
    expect(test_value).to eq(value_from_rb)
  end
end
