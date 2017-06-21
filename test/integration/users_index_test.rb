
require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

def setup
  @admin = users(:admin)
  @user = users(:michael)
end

test "admin can view index and it has pagination" do
  log_in_as_admin(@admin)
  assert is_logged_in?
  get users_path
  assert_template 'users/index'
  assert_select 'div.pagination'
  first_page_of_users = User.paginate(page: 1)
  first_page_of_users.each do |user|
    assert_select 'a[href=?]', user_path(user), text: user.name
    assert_select 'a[href=?]', edit_user_path(user), text: 'Redigera'
  end
end

test "common user should not be able to view /users" do
  log_in_as(@user)
  get users_path
  assert flash.empty?
  assert_redirected_to root_url
end

test "non-user should not be able to view /users" do
  get users_path
  assert_not flash.empty?
  assert_redirected_to login_path
end


end
