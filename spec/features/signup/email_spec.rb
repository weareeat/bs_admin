require 'spec_helper'

describe "> email", type: :request do
	context "> confimation" do	
		before :each do			
			User.destroy_all
			create_and_login_test_user
			expect(test_user.email_confirmation_token).to_not be_nil
			reload_test_user						
		end				

		it "> happy path" do
			get "/user/email-confirmation/#{test_user.email_confirmation_token}"
			expect(response).to redirect_to logged_path
			expect(test_user.email_confirmation_token).to be_nil
		end

		it "> invalid token" do
			get "/user/email-confirmation/#{test_user.email_confirmation_token}-make-it-invalid"
			expect(response).to have_http_status :unauthorized			
			expect(test_user.email_confirmation_token).to_not be_nil
		end

		it '> send token' do
			login_test_user			

			expect_post('/api/current_user/send_email_confirmation_email', {}, 1).to be_success			

			reload_test_user	

			expect($test_user).to model_be_equal_to($old_test_user).except({ 
				email_confirmation_token: :changed,
				updated_at: :recent
			})

			expect(last_email.to.first).to eq $test_user.email
			expect(last_email.subject).to include "Confirm your email account"
			expect(last_email.body).to include app_uri "email-confirmation", $test_user.email_confirmation_token
		end
	end

	context "> update" do	
		before :each do
			User.destroy_all
			create_and_login_test_user
			expect(test_user.email_confirmation_token).to_not be_nil
			reload_test_user
		end		

		let(:request_path) { '/api/current_user/update_email' }

		include_examples "> required params", {
	    request_path: '/api/current_user/update_email',
	    params: [:email]
	  }

		it '> happy path' do			
			new_email = "new@email.com"			
			expect_post(request_path, { email: new_email }, 1).to be_success			

			reload_test_user

			expect($test_user).to model_be_equal_to($old_test_user).except({ 
				email_confirmation_token: :changed,
				email: new_email,
				updated_at: :recent
			})

			expect(last_email.to.first).to eq $test_user.email
			expect(last_email.subject).to include "Confirm your email account"
			expect(last_email.body).to include app_uri "email-confirmation", $test_user.email_confirmation_token
		end
			
  	it '> invalid email' do
			post request_path, { email: "newemail.com" }
			expect(response).to have_json_error :unprocessable_entity, [:email]

			reload_test_user

			expect($test_user).to model_be_equal_to($old_test_user)
			expect(sent_email_count).to eq 0			
  	end
	end
end
