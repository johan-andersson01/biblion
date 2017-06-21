require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @admin = users(:admin)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: {name: @user.name, telephone: 123443211, email: "foo@invalid", oldpassword: "password"}}
    assert_template 'users/edit'
    assert_select "#error" do |e|
      assert_select e, "li", 1 # invalid email
    end
  end

  # test "successful admin edit" do
  #   log_in_as_admin(@admin)
  #   assert is_logged_in?
  #   get edit_user_path(@user)
  #   tel = "123443211"
  #   email = "foo@valid.com"
  #   patch user_path(@user), params: { user: {name: @user.name, telephone: tel, email: email, oldpassword: "foobar"}}
  #   assert_not flash.empty?
  #   assert_select ".alert-danger", false
  #   assert_select ".alert-success" #TODO: why is this not present?
  #   assert_redirected_to users_url
  #   assert_equal email, @user.email #TODO: why wrong?
  #   assert_equal tel, @user.telephone #TODO: why wrong?
  # end

  # test "invalid admin edit but correct pw" do #TODO: why fail?
  #   log_in_as_admin(@admin)
  #   assert is_logged_in?
  #   get edit_user_path(@user)
  #   tel = "123"
  #   email = "foo@valid.com"
  #   patch user_path(@user), params: { user: {name: @user.name, telephone: tel, email: email, oldpassword: "foobar"}}
  #   assert_not flash.empty?
  #   assert_select ".alert-danger"
  #   assert_select ".alert-success", false
  #   assert_template 'users/edit'
  #   assert_select "#error" do |e|
  #     assert_select e, "li", 1 # invalid tel
  #   end
  # end

  test "valid admin edit but wrong password" do
    log_in_as_admin(@admin)
    assert is_logged_in?
    get edit_user_path(@user)
    tel = "123443211"
    email = "edited@valid.com"
    patch user_path(@user), params: { user: {name: @user.name, telephone: tel, email: email, oldpassword: "asdsdf"}}
    assert_not flash.empty?
    assert_template 'users/edit'
    assert_select ".alert-danger"
  end

  test "valid edit but wrong current password" do
    log_in_as(@user)
    get edit_user_path(@user)
    tel = "123443211"
    email = "foo@valid.com"
    patch user_path(@user), params: { user: {name: @user.name, telephone: tel, email: email, oldpassword: "foobar"}}
    assert_template 'users/edit'
    assert_select ".alert-danger"
  end

  test "successful user edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    tel = "123443211"
    email = "foo@valid.com"
    patch user_path(@user), params: { user: {name: @user.name, telephone: tel, email: email, oldpassword: "password"}}
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
                                            password_confirmation: "",
                                            oldpassword: "password" } }
  assert_not flash.empty?
  assert_redirected_to @user
  @user.reload
  assert_equal email, @user.email
  end
end
