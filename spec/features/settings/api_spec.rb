require 'spec_helper'

describe "> api", type: :request do  
  before :each do     
    BsAdmin::Settings.destroy_all
    @group_1 = BsAdmin::Settings.create :group_1, "Group 1" do |m|
      @subgroup_1 = m.group :subgroup_1, "Sub-Group 1" do |g|
        @subgroup_1_test_setting_1 = g.string "Test Setting 1", :test_setting_1, "Test Value 1"
        @subgroup_1_test_setting_2 = g.string "Test Setting 2", :test_setting_2, "Test Value 2"
      end
      @subgroup_2 = m.group :subgroup_2, "Sub-Group 2" do |g|
        @subgroup_2_test_setting_1 = g.string "Test Setting 1", :test_setting_1, "Test Value 1"
        @subgroup_2_test_setting_2 = g.string "Test Setting 2", :test_setting_2, "Test Value 2"
      end
    end
    
    @group_2 = BsAdmin::Settings.create :group_2, "Group 2" do |m|
      @subgroup_3 = m.group :subgroup_3, "Sub-Group 3" do |g|
        @subgroup_3_test_setting_1 = g.string "Test Setting 1", :test_setting_1, "Test Value 1"
        @subgroup_3_test_setting_2 = g.string "Test Setting 2", :test_setting_2, "Test Value 2"
      end
      @subgroup_4 = m.group :subgroup_4, "Sub-Group 4" do |g|
        @subgroup_4_test_setting_1 = g.image "Test Setting 1", :test_setting_1, nil
        @subgroup_4_test_setting_2 = g.image "Test Setting 2", :test_setting_2, nil
      end
    end
  end   

  it "> setting with 2 params" do
    actual = BsAdmin::Settings.setting :subgroup_3, :test_setting_1
    expect(actual).be eq @subgroup_3_test_setting_1.value
  end

  it "> setting with 3 params" do
    actual = BsAdmin::Settings.setting :group_2, :subgroup_3, :test_setting_1
    expect(actual).be eq @subgroup_3_test_setting_1.value
  end

  it "> image setting with 2 params" do
    actual = BsAdmin::Settings.setting :subgroup_4, :test_setting_1
    expect(actual).be eq @subgroup_4_test_setting_1.value
  end

  it "> image setting with 3 params" do
    actual = BsAdmin::Settings.setting :group_2, :subgroup_4, :test_setting_1
    expect(actual).be eq @subgroup_4_test_setting_1.value
  end

  it "> try get unexistent settings" do
    expect { BsAdmin::StringSetting.setting(:group_1, :subgroup_1, :unexistent) }.to raise_error
    expect { BsAdmin::StringSetting.setting(:unexistent, :subgroup_1, :test_setting_1) }.to raise_error
    expect { BsAdmin::StringSetting.setting(:group_1, :unexistent, :test_setting_1) }.to raise_error
  end

  it "destroy group" do
    BsAdmin::Settings.destroy_group :group_1
    expect(BsAdmin::SettingGroup.find_by_key(:group_1)).be eq nil
  end

  it "destroy subgroup" do
    BsAdmin::Settings.destroy_subgroup :subgroup_1
    expect(BsAdmin::SettingSubGroup.find_by_key(:subgroup_1)).be eq nil
  end

  it "destroy setting" do
    BsAdmin::Settings.destroy_setting :group_1, :subgroup_1, :test_setting_1    
    expect { BsAdmin::StringSetting.setting(:group_1, :subgroup_1, :test_setting_1) }.to raise_error
  end

  it "destroy all" do
    BsAdmin::Settings.destroy_all
    expect(BsAdmin::SettingGroup.all.count).be eq 0
    expect(BsAdmin::SettingSubGroup.all.count).be eq 0
    expect(BsAdmin::StringSetting.all.count).be eq 0
    expect(BsAdmin::ImageSetting.all.count).be eq 0
  end

  it "add_to_group" do
    BsAdmin::Settings.add_to_group :group_1 do |m|
      @subgroup_5 = m.group :subgroup_5, "Sub-Group 5"
    end
    expect(BsAdmin::SettingSubGroup.find_by_key(:subgroup_5)).be eq model_be_equal_to @subgroup_5
  end

  it "add_to_subgroup" do
    BsAdmin::Settings.add_to_subgroup :group_1, :subgroup_5 do |m|
      @subgroup_5_test_setting_1 = g.string "Test Setting 1", :test_setting_1, "Test Value 1"
    end    
    expected = BsAdmin::SettingSubGroup.find_by_key(:subgroup_5).settings.find_by_key(:test_setting_1)
    expect(BsAdmin::StringSettings.find_by_key(:subgroup_5)).be eq model_be_equal_to @subgroup_5_test_setting_1
  end

  it "try create duplicated group" do
    expect { BsAdmin::Settings.create :group_1, "Group 1" }.to raise_error      
  end

  it "try create duplicated subgroup" do
    BsAdmin::Settings.add_to_group :group_1 do |m|
      expect { m.group :subgroup_4, "Sub-Group 4" }.to raise_error
    end    
  end

  it "try create duplicated setting" do
    BsAdmin::Settings.add_to_subgroup :group_1, :subgroup_1 do |m|
      expect { g.string "Test Setting 1", :test_setting_1, "Test Value 1" }.to raise_error
    end        
  end
end