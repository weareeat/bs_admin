class CreateNestedNestedEntities < ActiveRecord::Migration
  def change
    create_table :nested_nested_entities do |t|
      t.string :string_param
      t.integer :nested_entity_id

      t.timestamps
    end
  end
end
