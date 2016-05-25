class CreateNestedEntities < ActiveRecord::Migration
  def change
    create_table :nested_entities do |t|
      t.string :string_param
      t.integer :partent_entity_id

      t.timestamps
    end
  end
end
