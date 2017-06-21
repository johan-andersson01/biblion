require 'test_helper'

class UsersDestroyTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @admin = users(:admin)
  end

  test "should fail to destroy user if admin wants to delete account, but enters wrong pw" do
   log_in_as_admin(@admin)
   assert_difference 'User.count', 0 do
     delete user_path(@user),  params: { user: { password: "foofar"} }
   end
   assert_not flash.empty?
   assert_template 'users/edit'
   assert_select ".alert-danger"
  end

  test "should  destroy user if admin wants to delete account" do
   log_in_as_admin(@admin)
   assert_difference 'User.count', -1 do
     delete user_path(@user),  params: { user: { password: "foobar"} }
   end
   assert_redirected_to users_url
   assert is_logged_in_as(@admin)
  end

  test "should fail to destroy user if user wants to delete account, but enters wrong pw" do
   log_in_as(@user)
   assert_difference 'User.count', 0 do
     delete user_path(@user),  params: { user: { password: "wrong_pw"} }
   end
   assert_not flash.empty?
   assert_template 'users/edit'
   assert_select ".alert-danger"
  end

  test "should  destroy user if user wants to delete account" do
   log_in_as(@user)
   assert_difference 'User.count', -1 do
     delete user_path(@user),  params: { user: { password: "password"} }
   end
   assert_redirected_to root_url
   assert_not is_logged_in?
  end
  end
