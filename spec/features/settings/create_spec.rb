require 'spec_helper'

RSpec.describe "> create", type: :request do  
  before :all do    
    BsAdmin::Settings.destroy_all

    @c = {}

    @c["group_1"] = BsAdmin::Settings.create :group_1, "Group 1", hint: "hint here" do |g|
      @c["subgroup_1"] = g.subgroup :subgroup_1, "Sub-Group 1", hint: "hint here" do |s|
        @c["subgroup_1_test_setting_1"] = s.string "Test Setting 1", :test_setting_1, "Test Value 1", hint: "hint here"
        @c["subgroup_1_test_setting_2"] = s.string "Test Setting 2", :test_setting_2, "Test Value 2"
      end
      @c["subgroup_2"] = g.subgroup :subgroup_2, "Sub-Group 2", hint: "hint here" do |s|
        @c["subgroup_2_test_setting_1"] = s.string "Test Setting 1", :test_setting_1, "Test Value 1", hint: "hint here"
        @c["subgroup_2_test_setting_2"] = s.string "Test Setting 2", :test_setting_2, "Test Value 2", hint: "hint here"
      end
    end
    
    @c["group_2"] = BsAdmin::Settings.create :group_2, "Group 2", hint: "hint here" do |g|
      @c["subgroup_3"] = g.subgroup :subgroup_3, "Sub-Group 3", hint: "hint here" do |s|
        @c["subgroup_3_test_setting_1"] = s.string "Test Setting 1", :test_setting_1, "Test Value 1", hint: "hint here"
        @c["subgroup_3_test_setting_2"] = s.string "Test Setting 2", :test_setting_2, "Test Value 2", hint: "hint here"
      end
      @c["subgroup_4"] = g.subgroup :subgroup_4, "Sub-Group 4", hint: "hint here" do |s|
        @c["subgroup_4_test_setting_1"] = s.string "Test Setting 1", :test_setting_1, "Test Value 1", hint: "hint here"
        @c["subgroup_4_test_setting_2"] = s.string "Test Setting 2", :test_setting_2, "Test Value 2", hint: "hint here"
      end
    end
  end  

  (1..2).each do |i|
    it "> creates group_#{i}" do 
      expect(@c["group_#{i}"]).to model_be_equal_to BsAdmin::SettingGroup.find(@c["group_#{i}"].id)
    end
  end

  (1..4).each do |i|
    it "> creates subgroup_#{i}" do 
      expect(@c["subgroup_#{i}"]).to model_be_equal_to BsAdmin::SettingSubGroup.find(@c["subgroup_#{i}"].id)
    end
    
    (1..2).each do |j|
      it "> creates subgroup_#{i}_test_setting_#{j}" do 
        expect(@c["subgroup_#{i}_test_setting_#{j}"]).to model_be_equal_to BsAdmin::StringSettins.find(@c["subgroup_#{i}_test_setting_#{j}"])
      end
    end
  end

end    