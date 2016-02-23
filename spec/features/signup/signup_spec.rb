require 'spec_helper'

describe "> signup", type: :request do
  before :each do
    User.destroy_all
  end

  include_examples "> required params", {
    request_path: 'user/signup',
    params: [:email, :password, :password_confirmation]
  }

  it "> happy path" do
    hash = test_user_hash
    post '/user/signup', hash
    expect(response).to have_http_status :ok
    
    signup_user = User.find_by_email(hash[:email])
    
    expect(signup_user).to_not be_nil
    expect(emails[0].subject).to include "Confirm your email account"
    expect(emails[1].subject).to include "Welcome"

    get '/api/current_user'       
    expect(response).to json_success_schema :user
    expect(json_response['email']).to eq(hash[:email])
  end

  it "> invalid password cofirmation" do
    hash = test_user_hash
    hash[:password_confirmation] = "xxxx"
    post '/user/signup', hash
    expect(response).to have_json_error :unprocessable_entity, [:password]
  end

  it "> duplicated email" do    
    post '/user/signup', test_user_hash
    expect(response).to have_http_status :ok
    expect(User.find_by_email(test_user_hash[:email])).to_not be_nil

    post '/user/signup', test_user_hash
    expect(response).to have_json_error :unprocessable_entity, [:email]
    expect(User.where("email = ?", test_user_hash[:email]).count).to eq(1)
  end

  it "> invalid password" do
    hash = test_user_hash
    hash[:password] = "12"
    post '/user/signup', hash
    expect(response).to have_json_error :unprocessable_entity, [:password]
  end

end
