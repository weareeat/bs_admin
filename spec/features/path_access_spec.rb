# require 'spec_helper'

# describe "> all unlogged unauthorized paths", type: :request do
# 	before :all do
# 		test_user_should_be_unlogged
# 	end

# 	Rails.application.routes.routes.to_a.each do |route|
# 		if route.path.spec.to_s.start_with? "/api"
# 			verb = route.verb.source.to_s.delete('$'+'^').downcase.to_sym
# 			path = route.path.spec.to_s

# 			path.slice!('(.:format)')
						
# 			unless verb == :post and path == "/api/current_user/reset_password"
# 				it "> try to #{verb} in #{path}" do
# 					send verb, path
# 					expect(response).to have_http_status :unauthorized
# 				end
# 			end
# 		end
# 	end
# end
