require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:admin)
    @user = users(:michael)
    @other_user = users(:archer)
  end

test "other user should not be able to show other user's full profile" do
  log_in_as(@user)
  assert is_logged_in?
  get user_path(@other_user)
  assert flash.empty?
  assert_equal request.path, user_path(@other_user)
  assert_select ".users" do |e|
    assert_select e, "li", 4
  end
end

test "admin  should be able to show other user's full profile" do
  log_in_as(@admin)
  assert is_logged_in?
  get user_path(@other_user)
  assert flash.empty?
  assert_equal request.path, user_path(@other_user)
  assert_select ".users" do |e|
    assert_select e, "li", 8
  end
end
end
