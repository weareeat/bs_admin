class SeedMainBsAdminSettings < ActiveRecord::Migration
  def up    
    BsAdmin::Settings.create "Main" do |m|
      m.group :general, "General" do |g|
        g.string "Website Title", :website_title, "Dummy"
      end
    end
  end

  def down
    BsAdmin::Settings.destroy_group :general
  end
end
