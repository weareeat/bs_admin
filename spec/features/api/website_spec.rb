require 'spec_helper'

describe "> website", type: :request do  
  before :each do     
    Website.destroy_all      
    User.destroy_all
    create_and_login_test_user
  end       

  it "> index" do
    (1..3).each{ |i| test_user.websites.create({ name: "website name #{i}" }) }
    get "/api/website"      
    expect_to_have_json_model_array_success_response response, :website, count: 3
  end

  it "> show" do
    model = test_user.websites.create({ name: "website name 1" })
    get "/api/website/#{model.id}"      
    expect(response).to json_success_schema :website
  end

  it "> create" do
    post "/api/website", { website: { name: "website name 1" } }    
    expect(response).to json_success_schema :website
    model_from_db = Website.find json_response[:id]    
    expect(json_response).to model_be_equal_to(model_from_db).except({ 
      user_id: :ignore,
      created_at: :ignore,
      updated_at: :ignore
    })
  end

  it "> create (wrong input)" do
    post "/api/website", { any_wrong_param: "any wrong value" }
    expect(response).to have_json_error :bad_request
    expect(Website.count).to eq 0
  end

  it "> update" do
    test_model = test_user.websites.create({ name: "website name 1" })    
    test_name = "website name 2"
    put "/api/website/#{test_model.id}", { website: { name: test_name } }
    expect(response).to json_success_schema :website
    model_from_db = Website.find json_response[:id]
    expect(json_response).to model_be_equal_to(model_from_db).except({ 
      user_id: :ignore,
      created_at: :ignore,
      updated_at: :ignore
    })
    expect(model_from_db.name).to eq test_name
  end

  it "> update (wrong input)" do
    test_model = test_user.websites.create({ name: "website name 1" })        
    put "/api/website/#{test_model.id}", { any_wrong_param: "any wrong value" }
    expect(response).to have_json_error :bad_request
  end

  it "> update (wrong id)" do
    test_model = test_user.websites.create({ name: "website name 1" })            
    test_name = "website name 1"
    put "/api/website/#{test_model.id + 1}", { website: { name: test_name } }    
    expect(response).to have_json_error :not_found
    model_from_db = Website.find test_model.id
    expect(test_model).to model_be_equal_to model_from_db
  end

  it "> destroy" do
    test_model = test_user.websites.create({ name: "website name 1" }) 
    expect(Website.count).to eq 1       
    delete "/api/website/#{test_model.id}"
    expect(Website.count).to eq 0
  end

  it "> destroy (wrong id)" do
    test_model = test_user.websites.create({ name: "website name 1" }) 
    expect(Website.count).to eq 1       
    delete "/api/website/#{test_model.id + 1}"
    expect(response).to have_json_error :not_found
    expect(Website.count).to eq 1
  end
end
