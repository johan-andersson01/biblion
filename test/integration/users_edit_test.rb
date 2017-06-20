require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: {name: @user.name, telephone: 123443211, email: "foo@invalid"}}
    assert_template 'users/edit'
    assert_select "#error" do |e|
      assert_select e, "li", 1 # invalid email
    end
  end

  test "successful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    tel = "123443211"
    email = "foo@valid.com"
    patch user_path(@user), params: { user: {name: @user.name, telephone: tel, email: email}}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal email, @user.email
    assert_equal tel, @user.telephone
  end

  test "successful edit with friendly forwarding" do
  get edit_user_path(@user)
  log_in_as(@user)
  assert_redirected_to edit_user_url(@user)
  email = "foo@foobar.com"
  patch user_path(@user), params: { user: { name:  @user.name,
                                            email: email,
                                            password:              "",
                                            password_confirmation: "" } }
  assert_not flash.empty?
  assert_redirected_to @user
  @user.reload
  assert_equal email, @user.email
end
end
