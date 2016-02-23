require 'spec_helper'

describe "> login", type: :request do
	before :all do
		create_and_login_test_user
	end

	include_examples "> required params", {
    request_path: '/user/login',
    params: [:email, :password]
  }

	it "> happy path with /logout" do		
		post '/user/login', { email: test_user_hash[:email], password: test_user_hash[:password] }
		expect(response).to have_http_status :ok

		get '/api/current_user'		
		expect(response).to json_success_schema :user
		expect(json_response['email']).to eq test_user_hash[:email]

		get '/user/logout'
		expect(response).to redirect_to root_path
	end

	it "> happy path with remember me and /logout" do
		post '/user/login', { email: test_user_hash[:email], password: test_user_hash[:password], remember: true }
		expect(response).to have_http_status :ok
		expect(cookies['remember_me_token']).to be_truthy

		controller.reset_session

		get '/api/current_user'
		expect(response).to json_success_schema :user
		expect(json_response['email']).to eq test_user_hash[:email]

		get '/user/logout'
		expect(response).to redirect_to root_path

		get '/api/current_user'
		expect(response).to have_http_status :unauthorized
	end

	it "> invalid password" do
		post '/user/login', { email: "user@login.test", password: "4321" }		
		expect(response).to have_json_error :unprocessable_entity, [:email, :password]
	end

	it "> invalid email" do
		post '/user/login', { email: "non_existent_user@login.test", password: "1234" }		
		expect(response).to have_json_error :unprocessable_entity, [:email, :password]
	end
end
