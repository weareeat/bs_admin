class AdminJsonApiTest < ActiveRecord::Base  
  # :protected_param

  bs_admin do |c|
    c.fields do |f|    
      f.string :hidden_param, hidden: true
      f.string :non_required_param
      f.string :required_param, required: true
      f.view :view_type_param
    end

    c.title_field :required_param
    c.index_fields [:required_param, :created_at]

    c.sort :created_at
    c.populate_batch_count 5..20
  end

end
