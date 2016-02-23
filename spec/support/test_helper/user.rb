module TestHelper::User
  TEST_USER_EMAIL = "testuser@email.com"
  TEST_USER_PASSWORD = "1234"

  def test_user_hash
    {      
      email: TEST_USER_EMAIL,      
      password: TEST_USER_PASSWORD,
      password_confirmation: TEST_USER_PASSWORD
    }        
  end

  def create_user email, password
    hash = test_user_hash
    hash[:email] = email
    hash[:password] = password
    hash[:password_confirmation] = password
    post 'user/signup', hash
  end

  def create_and_login_test_user    
    create_user TEST_USER_EMAIL, TEST_USER_PASSWORD
    $test_user_id = User.find_by_email(TEST_USER_EMAIL).id
    clear_emails
    reload_test_user
  end

  def test_user
    User.find $test_user_id
  end

  def reload_test_user
    $old_test_user = $test_user.clone if $test_user != nil
    $test_user = test_user
  end
  
  def login_user email, password
    post user_login_path, { email: email, password: password }
  end

  def login_test_user
    login_user TEST_USER_EMAIL, TEST_USER_PASSWORD    
  end

  def logout_user
    get '/user/logout'    
  end

  def test_user_logged?
    get '/api/current_user'
    response.status == 200 # ok
  end

  def test_user_should_be_logged    
    login_test_user unless test_user_logged?
  end

  def test_user_should_be_unlogged
    logout_user if test_user_logged?
  end

  def create_and_log_test_user
    create_and_login_test_user
    login_test_user
  end
end