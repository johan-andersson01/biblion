require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:admin)
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should get signup" do
    get signup_url
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
end

test "should redirect show when not logged in" do
    get user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
end

test "should redirect edit when logged in as wrong user" do
  log_in_as(@other_user)
  get edit_user_path(@user)
  assert flash.empty?
  assert_redirected_to root_url
end

test "should redirect update when logged in as wrong user" do
  log_in_as(@other_user)
  prev_name = @user.name
  patch user_path(@user), params: { user: { name: "Hacked name",
                                            email: "Hacked email",
                                            oldpassword: "password9000" } }
  assert_equal(prev_name, @user.name)
  assert_not flash.empty?
  assert_redirected_to root_url
end

test "should allow admin to update user profiles" do
  log_in_as_admin(@admin)
  prev_name = @user.name
  patch user_path(@user), params: { user: { name: "Admin name",
                                            oldpassword: "foobar9000" } }
  assert_equal("Admin name", @user.reload.name)
  assert_not flash.empty?
  assert_redirected_to users_url
end

test "should not allow the admin attribute to be edited via the web" do
   log_in_as(@other_user)
   assert_not @other_user.admin?
   patch user_path(@other_user), params: {
                                   user: { oldpassword: "password9000",
                                           admin: true } }
   assert_not @other_user.reload.admin?
 end


 test "should not allow the disabled attribute to be edited via the web for non-admins" do
  log_in_as(@other_user)
  assert_not @other_user.admin?
  prev_value = @other_user.disabled
  assert_not prev_value
  patch user_path(@other_user), params: {
                                  user: { oldpassword: "password9000",
                                          disabled: true } }
  assert_equal(prev_value, @other_user.reload.disabled)
end

test "should allow the disabled attribute to be edited via the web for admins" do
  log_in_as_admin(@admin)
  assert @admin.admin?
  assert_not @other_user.disabled
  patch user_path(@other_user), params: {
                                  user: { oldpassword: "foobar9000",
                                          disabled: true } }
  assert @other_user.reload.disabled
end

 test "should redirect destroy when not logged in" do
   assert_no_difference 'User.count' do
     delete user_path(@user)
   end
   assert_redirected_to login_url
 end

 test "should redirect destroy when logged in as a non-admin" do
  log_in_as(@user)
  assert_no_difference 'User.count' do
    delete user_path(@other_user)
  end
  assert_redirected_to root_url
end
end
