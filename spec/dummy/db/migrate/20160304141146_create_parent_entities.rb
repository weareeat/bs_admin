class CreateParentEntities < ActiveRecord::Migration
  def change
    create_table :parent_entities do |t|
      t.string :string_param

      t.timestamps
    end
  end
end
