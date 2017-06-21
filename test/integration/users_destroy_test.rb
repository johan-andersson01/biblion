# require 'test_helper'
#
# class UsersEditTest < ActionDispatch::IntegrationTest
#   def setup
#     @user = users(:michael)
#     @admin = users(:admin)
#   end
#
# test "successful admin edit" do
#   log_in_as_admin(@admin)
#   assert is_logged_in?
#   get edit_user_path(@user)
#   tel = "123443211"
#   email = "foo@valid.com"
#   destroy user_path(@user), params: { user: {name: @user.name, telephone: tel, email: email, oldpassword: "foobar"}}
#   assert_not flash.empty?
#   #assert_select ".alert-success"
#   assert_redirected_to @user
#   @user.reload
#   assert_equal email, @user.email
#   assert_equal tel, @user.telephone
# end
#
# test "valid admin edit but wrong password" do
#   log_in_as_admin(@admin)
#   assert is_logged_in?
#   get edit_user_path(@user)
#   tel = "123443211"
#   email = "foo@valid.com"
#   patch user_path(@user), params: { user: {name: @user.name, telephone: tel, email: email, oldpassword: "asdsdf"}}
#   assert_not flash.empty?
#   assert_template 'users/edit'
#   assert_select ".alert-danger"
# end
