require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:mark)
  end

  test "login with invalid information" do
    get login_path                                        # Visit the login path.
    assert_template 'sessions/new'                        # Verify that the new sessions form renders properly.
    post login_path, session: { email: "", password: "" } # Post to the sessions path with an invalid params hash.
    assert_template 'sessions/new'                        # Verify that the new sessions form gets re-rendered and that a flash message appears
    assert_not flash.empty?                               # Verify that a flash message appears
    get root_path                                         # Visit another page (such as the Home page)
    assert flash.empty?                                   # Verify that the flash message doesn’t appear on the new page
  end
  
  test "login with valid information" do
    get login_path
    post login_path, session: { email: @user.email, password: 'password' }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end
  
  test "login with valid information followed by logout" do
    get login_path
    post login_path, session: { email: @user.email, password: 'password' }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    delete logout_path    # Simulate a user clicking logout in a second window.
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
  
  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not_nil cookies['remember_token']
  end

  test "login without remembering" do
    log_in_as(@user, remember_me: '0')
    assert_nil cookies['remember_token']
  end
end
