require 'spec_helper'

RSpec.describe "> api", type: :request do  
  before :each do     
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
        @subgroup_4_test_setting_1 = s.image :test_setting_1, "Test Setting 1", "spec_test_files/image_setting_value.jpg"
        @subgroup_4_test_setting_2 = s.string :test_setting_2, "Test Setting 2", "Test Value 2"
      end
    end        
  end   

  it "> setting" do
    actual = BsAdmin::Settings.setting :group_2, :subgroup_3, :test_setting_1
    expect(actual).to eq @subgroup_3_test_setting_1.value
  end

  it "> image setting" do
    actual = BsAdmin::Settings.image_setting :group_2, :subgroup_4, :test_setting_1
    expect(actual.to_s).to eq @subgroup_4_test_setting_1.value.to_s
  end

  it "> try get unexistent settings" do
    expect { BsAdmin::StringSetting.setting(:group_1, :subgroup_1, :unexistent) }.to raise_error
    expect { BsAdmin::StringSetting.setting(:unexistent, :subgroup_1, :test_setting_1) }.to raise_error
    expect { BsAdmin::StringSetting.setting(:group_1, :unexistent, :test_setting_1) }.to raise_error
  end

  it "destroy group" do
    BsAdmin::Settings.destroy_group :group_1
    expect(BsAdmin::SettingGroup.find_by_key(:group_1)).to eq nil
  end

  it "destroy subgroup" do
    BsAdmin::Settings.destroy_subgroup :group_1, :subgroup_1
    expect(BsAdmin::SettingSubGroup.find_by_key(:subgroup_1)).to eq nil
  end

  it "destroy setting" do
    BsAdmin::Settings.destroy_setting :group_1, :subgroup_1, :test_setting_1    
    expect { BsAdmin::StringSetting.setting(:group_1, :subgroup_1, :test_setting_1) }.to raise_error
  end

  it "destroy all" do
    BsAdmin::Settings.destroy_all
    expect(BsAdmin::SettingGroup.all.count).to eq 0
    expect(BsAdmin::SettingSubGroup.all.count).to eq 0
    expect(BsAdmin::StringSetting.all.count).to eq 0
    expect(BsAdmin::ImageSetting.all.count).to eq 0
  end

  it "add_to_group" do
    BsAdmin::Settings.add_to_group :group_1 do |g|
      @subgroup_5 = g.create_subgroup :subgroup_5, "Sub-Group 5"
    end
    actual = BsAdmin::Settings.subgroup :group_1, :subgroup_5
    expect(actual.key).to eq "subgroup_5"
    expect(actual.display_name).to eq "Sub-Group 5"    
  end

  it "add_to_subgroup" do
    BsAdmin::Settings.add_to_subgroup :group_1, :subgroup_2 do |s|
      @subgroup_2_test_setting_5 = s.string :test_setting_5, "Test Setting 5", "Test Value 5"
    end

    actual = BsAdmin::Settings.subgroup(:group_1, :subgroup_2).find_setting_by_key!(:test_setting_5)
    expect(actual.key).to eq "test_setting_5"
    expect(actual.display_name).to eq "Test Setting 5"
    expect(actual.value).to eq "Test Value 5"
  end

  it "try create duplicated group" do
    expect { BsAdmin::Settings.create_group :group_1, "Group 1" }.to raise_error      
  end

  it "try create duplicated subgroup" do
    BsAdmin::Settings.add_to_group :group_1 do |g|
      expect { g.create_subgroup :subgroup_1, "Sub-Group 1" }.to raise_error
    end    
  end

  it "try create duplicated setting" do
    BsAdmin::Settings.add_to_subgroup :group_1, :subgroup_1 do |s|
      expect { s.string :test_setting_1, "Test Setting 1", "Test Value 1" }.to raise_error
    end        
  end
end