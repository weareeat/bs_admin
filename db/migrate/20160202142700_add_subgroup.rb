class AddSubgroup < ActiveRecord::Migration
  def change
    rename_table :bs_admin_setting_groups, :bs_admin_setting_sub_groups

    rename_column :bs_admin_string_settings, :setting_group_id, :setting_sub_group_id
    rename_column :bs_admin_text_settings, :setting_group_id, :setting_sub_group_id
    rename_column :bs_admin_boolean_settings, :setting_group_id, :setting_sub_group_id

    add_column :bs_admin_setting_sub_groups, :setting_group_id

    create_table :bs_admin_setting_groups do |t|
      t.string :key, :unique => true
      t.string :display_name, :unique => true      
      t.text :hint
      t.timestamps
    end

    BsAdmin::SettingSubGroup.all.group_by(:main_group).each do |main_group, items|
      g = BsAdmin::SettingGroup.create({
        key: main_group.underscore
        display_name: main_group
      })
      items.each do |i|        
        i.setting_group_id = g.id
        i.save
      end
    end

    # remove_column :bs_admin_setting_sub_groups, :main_group
  end
end
