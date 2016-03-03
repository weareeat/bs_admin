require 'spec_helper'

describe "> admin_json_api", type: :request do  
  before :each do     
    @created = []
    (1..3).each do |i|
      @created << AdminJsonApiTest.create({
        protected_param: "protected_param #{i}",
        hidden_param: "hidden_param #{i}",
        non_required_param: "non_required_param #{i}",
        required_param: "required_param #{i}",
        view_type_param: "view_type_param #{i}"
      })
    end

    @first_created = @created[0]

    @meta = AdminJsonApiTest.meta
    @entity_path = @meta.path 
    @entity_name   
  end
  
  it "> list" do  
    get "/entities/#{@entity_path}"
    expect(response).to be_success
    parsed = json_response_array
    expect(parsed.count).to eq 3
    
    parsed.each do |p| 
      expect(p[:protected_param]).to be_nil
      expect(p[:hidden_param]).to be_nil
      expect(p[:non_required_param]).to be_nil
      expect(p[:required_param]).to not_be_nil
      expect(p[:view_type_param]).to be_nil
    end      
  end

  it "> create" do
    post "/entities/#{@entity_path}", { @entity_name => {      
      non_required_param: "non_required_param created",
      required_param: "required_param created"
    } }
    expect(response).to be_success
    expect(json_response).to match_model_schema :spec_admin_json_api_test

    expect(json_response[:non_required_param]).to not_be_nil
    expect(json_response[:required_param]).to not_be_nil

    expect(AdminJsonApiTest.all.count).to eq 4
  end

  it "> get" do
    get "/entities/#{@entity_path}/#{@first_created.id}"
    expect(response).to be_success
    expect(json_response).to match_model_schema :spec_admin_json_api_test

    expect(json_response[:protected_param]).to be_nil
    expect(json_response[:hidden_param]).to be_nil
    expect(json_response[:non_required_param]).to not_be_nil
    expect(json_response[:required_param]).to not_be_nil
    expect(json_response[:view_type_param]).to not_be_nil
  end

  it "> update" do
    changed_param = "changed param"
    put "/entities/#{@entity_path}/#{@first_created.id}", { @entity_name => {      
      non_required_param: @first_created[:non_required_param],
      required_param: changed_param
    } }
    expect(response).to be_success
    expect(json_response).to match_model_schema :spec_admin_json_api_test

    actual = AdminJsonApiTest.find(@first_created.id)

    expect(actual.required_param).to eq changed_param
  end

  it "> destroy" do
    delete "/entities/#{@entity_path}/#{@first_created.id}"
    expect(response).to be_success
    expect(json_response).to match_model_schema :spec_admin_json_api_test

    actual = AdminJsonApiTest.find(@first_created.id)

    expect(actual).to eq nil
  end

  [:create, :update].each do |action|    
    def execute_test input_params, error_params
      if action == :create
        post "/entities/#{@entity_path}", { @entity_name => input_params }
      elsif action == :update
        put "/entities/#{@entity_path}/#{@first_created.id}", { @entity_name => input_params }
      end

      expect(response).to have_json_error :unprocessable_entity, error_params
      expect(AdminJsonApiTest.all.count).to eq 3
    end
    
    it "> try #{action} with required param as nil" do
      execute_test({      
        non_required_param: "non_required_param created",
        required_param: nil
      }, [:required_param])
    end

    it "> try #{action} with required param as empty string" do
      execute_test({      
        non_required_param: "non_required_param created",
        required_param: ""
      }, [:required_param])
    end

    it "> try #{action} without required param" do
      execute_test({ non_required_param: "non_required_param created" }, [:required_param])
    end

    it "> try #{action} passing protected param" do
      execute_test({      
        non_required_param: "non_required_param created",
        required_param: "required_param created",
        protected_param: nil
      }, [:protected_param])
    end

    it "> try #{action} passing view type param" do
      execute_test({      
        non_required_param: "non_required_param created",
        required_param: "required_param created",
        view_type_param: nil
      }, [:view_type_param])
    end

    it "> try #{action} passing hidden param" do
      execute_test({      
        non_required_param: "non_required_param created",
        required_param: "required_param created",
        hidden_param: nil
      }, [:hidden_param])
    end
  end

  it "> try destroy with wrong id" do
    delete "/entities/#{@entity_path}/wrong_id"
    expect(response).to have_json_error :unprocessable_entity, [:id]    
  end
end
