class CreateExamples < ActiveRecord::Migration
  def change
    create_table :examples do |t|
      t.string :string_attribute
      t.boolean :checkbox_attribute

      t.timestamps
    end
  end
end
