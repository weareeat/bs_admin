class CreateCreateAllTypesTests < ActiveRecord::Migration
  def change
    create_table :spec_create_all_types_tests do |t|
      t.text :custom_param
      t.boolean :checkbox_param
      t.string :email_param
      t.string :password_param
      t.string :string_param
      t.money :currency_param
      t.string :permalink_param
      t.text :text_param
      t.date :date_param
      t.string :image_param
      t.string :radiogroup_param
      t.time :time_param
      t.datetime :datetime_param
      t.float :number_param
      t.string :select_param
      t.text :wysi_param
      t.string :file_param
      t.money :money_param
      t.integer :integer_param
      t.string :color_picker_param
      t.string :tags_param
      t.text :view_param

      t.timestamps
    end
  end
end
