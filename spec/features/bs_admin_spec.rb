# require 'spec_helper'
# require 'debugger'

# describe "> bs_admin", type: :model do
#   BsAdmin.classes.each do |c|
#     it "> #{c.to_s} creation" do
#       expect(c.new).to be_truthy
#     end

#     it "> #{c.to_s} meta" do      
#       expect(c.meta).to be_a BsAdmin::Meta
#     end
#   end
# end

# describe "/admin", type: :feature do
#   context "> unlogged" do
#     before :all do
#       Capybara.reset_sessions!
#     end

#     it "> login" do
#       visit "/admin"
#       fill_in "password", with: ENV["ADMIN_PASSWORD"]
#       click_on "Sign in"
#       expect(current_path).to eq bs_admin.settings_group_path    
#     end    
#   end

#   context "> logged" do
#     before :each do
#       Capybara.reset_sessions!
#       visit "/admin"
#       fill_in "password", with: ENV["ADMIN_PASSWORD"]
#       click_on "Sign in"      
#     end

#     it "> logout" do
#       click_on "Logout"
#       expect(current_path).to eq bs_admin.root_path
#     end
    
#     it "> create a blog post" do
#       visit "/admin"
#       # save_and_open_page

#       click_on "Blog Posts"    

#       click_on "New Blog Post"    

#       create_form_hash = create_hash(BlogPost)
#       fill_form :blog_post, create_form_hash
#       click_on "Save"    

#       last_created_hash = BlogPost.order(:created_at).last.attributes

#       create_form_hash.each do |k, v|
#         unless v.is_a?(File)
#           expect(last_created_hash[k.to_s]).to eq v
#         end
#       end
#     end

#     it "> upadate a blog post" do
#       visit "/admin"

#       click_on "Blog Posts"

#       last_created_hash = BlogPost.order(:created_at).last.attributes

#       within "#blog_post_#{last_created_hash['id']}" do 
#         click_on "Edit"
#       end

#       update_form_hash = create_hash(BlogPost)
#       fill_form :blog_post, update_form_hash
#       click_on "Save"    

#       last_updated_hash = BlogPost.order(:updated_at).last.attributes

#       update_form_hash.each do |k, v|
#         unless v.is_a?(File)
#           expect(last_updated_hash[k.to_s]).to eq v
#         end
#       end
      
#       expect(last_updated_hash[:id]).to eq last_created_hash[:id]
#     end
#   end
# end