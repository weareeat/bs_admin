require 'spec_helper'

RSpec.describe "> admin_json_api", type: :request do  
  before :each do     
    BsAdmin::Settings.destroy_all
    @group_1 = BsAdmin::Settings.group :group_1, "Group 1" do |m|
      @subgroup_1 = m.subgroup :subgroup_1, "Sub-Group 1" do |g|
        @subgroup_1_test_setting_1 = g.string "Test Setting 1", :test_setting_1, "Test Value 1"
        @subgroup_1_test_setting_2 = g.string "Test Setting 2", :test_setting_2, "Test Value 2"
      end
      @subgroup_2 = m.subgroup :subgroup_2, "Sub-Group 2" do |g|
        @subgroup_2_test_setting_1 = g.string "Test Setting 1", :test_setting_1, "Test Value 1"
        @subgroup_2_test_setting_2 = g.string "Test Setting 2", :test_setting_2, "Test Value 2"
      end
    end
    
    @group_2 = BsAdmin::Settings.group :group_2, "Group 2" do |m|
      @subgroup_3 = m.subgroup :subgroup_3, "Sub-Group 3" do |g|
        @subgroup_3_test_setting_1 = g.string "Test Setting 1", :test_setting_1, "Test Value 1"
        @subgroup_3_test_setting_2 = g.string "Test Setting 2", :test_setting_2, "Test Value 2"
      end
      @subgroup_4 = m.subgroup :subgroup_4, "Sub-Group 4" do |g|
        @subgroup_4_test_setting_1 = g.string "Test Setting 1", :test_setting_1, "Test Value 1"
        @subgroup_4_test_setting_2 = g.string "Test Setting 2", :test_setting_2, "Test Value 2"
      end
    end
  end       

  it "> groups" do    
    get "/settings"    
    expect(response).to be_success
    parsed = json_response_array
    expect(parsed.count).to eq 2
    parsed.each{ |i| expect(r).to match_model_schema :group }
    expect(parsed[0].key).to eq @group_1.key
    expect(parsed[1].key).to eq @group_2.key
  end

  it "> subgroups" do    
    get "/settings/#{@group_1.key}"
    expect(response).to be_success
    parsed = json_response_array
    expect(parsed.count).to eq 2
    parsed.each{ |i| expect(r).to match_model_schema :subgroup }
    expect(parsed[0].key).to eq @subgroup_1.key
    expect(parsed[1].key).to eq @subgroup_2.key
  end

  it "> settings" do    
    get "/settings/#{@group_1.key}/#{@subgroup_1.key}"
    expect(response).to be_success
    parsed = json_response_array
    expect(parsed.count).to eq 2
    parsed.each{ |i| expect(r).to match_model_schema :setting }
    expect(parsed[0].key).to eq @subgroup_1_test_setting_1.key
    expect(parsed[1].key).to eq @subgroup_1_test_setting_2.key
  end

  it "> show" do
    get "/settings/#{@group_1.key}/#{@subgroup_1.key}/#{@subgroup_1_test_setting_1.key}"
    expect(response).to be_success
    expect(json_response).to match_model_schema :setting
  end

  it "> update" do
    test_value = "Test Value A"
    put "/settings/#{@group_1.key}/#{@subgroup_1.key}/#{@subgroup_1_test_setting_1.key}", { setting: { value: test_value } }
    expect(response).to json_success_schema :setting
    
    model_from_db = BsAdmin::Settings.setting @group_1.key, @subgroup_1.key, @subgroup_1_test_setting_1.key
    
    expect(@subgroup_1_test_setting_1).to model_be_equal_to(model_from_db).except({ 
      value: test_value,
      created_at: :ignore,
      updated_at: :ignore
    })    
  end
end
