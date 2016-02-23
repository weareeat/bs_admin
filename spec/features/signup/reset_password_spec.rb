require 'spec_helper'

describe "> reset password", type: :request do	
	["unlogged"].each do |user_status|
		include_examples "> required params", {
	    request_path: "/user/send-reset-password-token",
	    params: [:email]
	  }

	  include_examples "> required params", {
	    request_path: "/user/reset-password",
	    params: [:token, :password_confirmation, :password]
	  }

		before :each do
			User.destroy_all
			create_and_login_test_user			
			test_user_should_be_logged if user_status == "logged"
			test_user_should_be_unlogged if user_status == "unlogged"
			post "/user/send-reset-password-token", { email: test_user.email } if user_status == "unlogged"
			post "/api/current_user/reset_password" if user_status == "logged"
			expect(response).to be_success
			expect(test_user.reset_password_token).to_not be_nil
		end

		it "> send link *with user #{user_status}" do						
			post "/user/send-reset-password-token", { email: $test_user.email } if user_status == "unlogged"
			post "/api/current_user/reset_password" if user_status == "logged"

			reload_test_user
			expect($test_user.reset_password_token).to_not be_nil
			expect(last_email.to.first).to eq $test_user.email
			expect(last_email.subject).to include "Your password reset request"
			expect(last_email.body).to include app_uri "reset-password", $test_user.reset_password_token
		end
		
		if user_status == "unlogged"
			it "> send token with wrong email" do						
				post "/user/send-reset-password-token", { email: "wrong@email.com" }
				expect(response).to have_json_error :unprocessable_entity, [:email]
			end
		end		

		it "> open form *with user #{user_status}" do
			get "user/reset-password/#{test_user.reset_password_token}"
			expect(response).to be_success
		end

		it "> open form / invalid token *with user #{user_status}" do
			get "user/reset-password/#{test_user.reset_password_token}-make-it-invalid"
			expect(response).to have_http_status :unauthorized
		end

		it "> reset password *with user #{user_status}" do
			post "/user/reset-password", {
				token: test_user.reset_password_token,
				password_confirmation: "4321",
				password: "4321"				
			}
			expect(response).to have_http_status :ok
		end

		it "> reset password / invalid token *with user #{user_status}" do		
			post "/user/reset-password", {
				token: "#{test_user.reset_password_token}-make-it-invalid",
				password_confirmation: "4321",
				password: "4321"				
			}
			expect(response).to have_http_status :unauthorized
		end

		it "> reset password / password_confirmation do not match *with user #{user_status}" do					
			post "/user/reset-password", {
				token: test_user.reset_password_token,				
				password_confirmation: "1234",
				password: "4321"				
			}			
			expect(response).to have_json_error :unprocessable_entity, [:password]
		end

		it "> reset password / invalid password *with user #{user_status}" do						
			post "/user/reset-password", {
				token: test_user.reset_password_token,
				password_confirmation: "12",
				password: "12"
			}
			expect(response).to have_json_error :unprocessable_entity, [:password]
		end
	end
end
