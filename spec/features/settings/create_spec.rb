describe "> create", type: :request do    
  before :all do       
    BsAdmin::Settings.destroy_all

    @created = []

    @created[:group_1] = BsAdmin::Settings.create :group_1, "Group 1", hint: "hint here" do |m|
      @created[:subgroup_1] = m.group :subgroup_1, "Sub-Group 1", hint: "hint here" do |g|
        @created[:subgroup_1_test_setting_1] = g.string "Test Setting 1", :test_setting_1, "Test Value 1", hint: "hint here"
        @created[:subgroup_1_test_setting_2] = g.string "Test Setting 2", :test_setting_2, "Test Value 2"
      end
      @created[:subgroup_2] = m.group :subgroup_2, "Sub-Group 2", hint: "hint here" do |g|
        @created[:subgroup_2_test_setting_1] = g.string "Test Setting 1", :test_setting_1, "Test Value 1", hint: "hint here"
        @created[:subgroup_2_test_setting_2] = g.string "Test Setting 2", :test_setting_2, "Test Value 2", hint: "hint here"
      end
    end
    
    @created[:group_2] = BsAdmin::Settings.create :group_2, "Group 2", hint: "hint here" do |m|
      @created[:subgroup_3] = m.group :subgroup_3, "Sub-Group 3", hint: "hint here" do |g|
        @created[:subgroup_3_test_setting_1] = g.string "Test Setting 1", :test_setting_1, "Test Value 1", hint: "hint here"
        @created[:subgroup_3_test_setting_2] = g.string "Test Setting 2", :test_setting_2, "Test Value 2", hint: "hint here"
      end
      @created[:subgroup_4] = m.group :subgroup_4, "Sub-Group 4", hint: "hint here" do |g|
        @created[:subgroup_4_test_setting_1] = g.string "Test Setting 1", :test_setting_1, "Test Value 1", hint: "hint here"
        @created[:subgroup_4_test_setting_2] = g.string "Test Setting 2", :test_setting_2, "Test Value 2", hint: "hint here"
      end
    end
  end  

  (1..2).each do |i|
    it "> creates group_#{i}" do 
      expect(@created["group_#{i}"]).to model_be_equal_to BsAdmin::SettingGroup.find(@created["group_#{i}"].id)
    end
  end

  (1..4).each do |i|
    it "> creates subgroup_#{i}" do 
      expect(@created["subgroup_#{i}"]).to model_be_equal_to BsAdmin::SettingSubGroup.find(@created["subgroup_#{i}"].id)
    end
    
    (1..2).each do |j|
      it "> creates subgroup_#{i}_test_setting_#{j}" do 
        expect(@created["subgroup_#{i}_test_setting_#{j}"]).to model_be_equal_to BsAdmin::StringSetting.find(@created["subgroup_#{i}_test_setting_#{j}"])
      end
    end
  end

end    