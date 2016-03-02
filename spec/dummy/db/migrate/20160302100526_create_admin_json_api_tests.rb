class CreateAdminJsonApiTests < ActiveRecord::Migration
  def change
    create_table :spec_admin_json_api_tests do |t|
      t.string :required_param
      t.string :non_required_param
      t.string :hidden_param
      t.string :protected_param
      t.string :view_type_param

      t.timestamps
    end
  end
end
