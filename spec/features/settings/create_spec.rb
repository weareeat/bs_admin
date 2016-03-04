require 'spec_helper'

RSpec.describe "> create", type: :request do  
  before :all do    
    BsAdmin::Settings.destroy_all

    @c = {}

    @c["group_1"] = BsAdmin::Settings.create_group :group_1, "Group 1", hint: "hint here" do |g|
      @c["subgroup_1"] = g.create_subgroup :subgroup_1, "Sub-Group 1", hint: "hint here" do |s|
        @c["subgroup_1_test_setting_1"] = s.string :test_setting_1, "Test Setting 1", "Test Value 1", hint: "hint here"
        @c["subgroup_1_test_setting_2"] = s.string :test_setting_2, "Test Setting 2", "Test Value 2", hint: "hint here"
      end
      @c["subgroup_2"] = g.create_subgroup :subgroup_2, "Sub-Group 2", hint: "hint here" do |s|
        @c["subgroup_2_test_setting_1"] = s.string :test_setting_1, "Test Setting 1", "Test Value 1", hint: "hint here"
        @c["subgroup_2_test_setting_2"] = s.string :test_setting_2, "Test Setting 2", "Test Value 2", hint: "hint here"
      end
    end
    
    @c["group_2"] = BsAdmin::Settings.create_group :group_2, "Group 2", hint: "hint here" do |g|
      @c["subgroup_3"] = g.create_subgroup :subgroup_3, "Sub-Group 3", hint: "hint here" do |s|
        @c["subgroup_3_test_setting_1"] = s.string :test_setting_1, "Test Setting 1", "Test Value 1", hint: "hint here"
        @c["subgroup_3_test_setting_2"] = s.string :test_setting_2, "Test Setting 2", "Test Value 2", hint: "hint here"
      end
      @c["subgroup_4"] = g.create_subgroup :subgroup_4, "Sub-Group 4", hint: "hint here" do |s|
        @c["subgroup_4_test_setting_1"] = s.string :test_setting_1, "Test Setting 1", "Test Value 1", hint: "hint here"
        @c["subgroup_4_test_setting_2"] = s.string :test_setting_2, "Test Setting 2", "Test Value 2", hint: "hint here"
      end
    end
  end  

  (1..2).each do |i|
    it "> creates group_#{i}" do      
      actual = BsAdmin::SettingGroup.find @c["group_#{i}"].id
      expect(actual.key).to eq "group_#{i}"
      expect(actual.display_name).to eq "Group #{i}"
      expect(actual.hint).to eq "hint here"

      expect(@c["group_#{i}"]).to model_be_equal_to actual
    end
  end

  (1..4).each do |i|
    it "> creates subgroup_#{i}" do
      actual = BsAdmin::SettingSubGroup.find @c["subgroup_#{i}"].id
      expect(actual.key).to eq "subgroup_#{i}"
      expect(actual.display_name).to eq "Sub-Group #{i}"
      expect(actual.hint).to eq "hint here"
      
      expect(@c["subgroup_#{i}"]).to model_be_equal_to actual      
    end
    
    (1..2).each do |j|      
      it "> creates subgroup_#{i}_test_setting_#{j}" do 
        actual = BsAdmin::StringSetting.find @c["subgroup_#{i}_test_setting_#{j}"].id
        expect(actual.key).to eq "test_setting_#{j}"
        expect(actual.display_name).to eq "Test Setting #{j}"
        expect(actual.hint).to eq "hint here"
        expect(actual.value).to eq "Test Value #{j}"
        
        expect(@c["subgroup_#{i}_test_setting_#{j}"]).to model_be_equal_to actual        
      end
    end
  end

end    