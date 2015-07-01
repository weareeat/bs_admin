class CreateBsAdmin < ActiveRecord::Migration
  def change
    create_table :bs_admin_assets do |t|
      t.string :type
      t.string :group
      t.string :file

      t.timestamps
    end

    create_table :bs_admin_setting_groups do |t|
      t.string :key, :unique => true
      t.string :display_name, :unique => true
      t.string :main_group

      t.timestamps
    end

    create_table :bs_admin_string_settings do |t|
      t.string :type
      t.integer :setting_group_id
      t.string :key, unique: true
      t.string :display_name, unique: true
      t.string :hint
      t.boolean :has_user_changed, default: false

      t.string :value
      t.timestamps
    end

    create_table :bs_admin_text_settings do |t|
      t.string :type
      t.integer :setting_group_id
      t.string :key, unique: true
      t.string :display_name, unique: true
      t.string :hint
      t.boolean :has_user_changed, default: false

      t.text :value
      t.timestamps
    end

    create_table :bs_admin_boolean_settings do |t|
      t.string :type
      t.integer :setting_group_id
      t.string :key, unique: true
      t.string :display_name, unique: true
      t.string :hint
      t.boolean :has_user_changed, default: false

      t.boolean :value
      t.timestamps
    end
  end
end
