class Post < ActiveRecord::Base
  bs_admin do |c|
    c.has_many :comments
    
    c.fields do |f|    
      f.string :title  
      f.wysi :content
    end

    c.title_field :title
    c.index_fields [:title, :created_at]

    c.sort :created_at
    c.populate_batch_count 5..20
  end
end
