namespace :bs_admin do  
  require 'bs_admin/faker_wrapper'
  include BsAdmin::FakerWrapper

  desc "Erase and fill database with auto generated fake data"
  task :populate => :environment do

    def populate_meta meta, batch_count, parent=nil, fill_relationships=true, print=true
      print "\n#{meta.name} batch #{batch_count}" if print
      meta.class.destroy_all if parent == nil

      (1..batch_count).each do
        hash = create_hash_from_meta meta
        object = create_object_from_meta meta, hash, parent

        if parent != nil and fill_relationships and meta.relationships != nil
          meta.relationships.each do |r|
            print "\n" if print
            populate_meta(r.meta, created_object.send(r.field))
          end
          print "\n" if print
        end
        print "." if print
      end
      print "\n" if print
    end

    BsAdmin.metas.each do |m|      
      populate_meta(m, m.populate_batch_count)
    end
  end
end
