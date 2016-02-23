class Comment < ActiveRecord::Base  
  bs_admin do |c|
    c.belongs_to :post
    c.fields do |f|      
      f.wysi :content
    end

    c.title_field :content
    c.index_fields [:content, :created_at]

    c.sort :created_at
    c.populate_batch_count 5..20
  end
end
