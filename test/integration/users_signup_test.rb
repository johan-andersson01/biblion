require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         landscape: "Mars",
                                         location: "Venus",
                                         password:              "foo",
                                         password_confirmation: "bar",  terms_of_service: "1"  } }
    end
    assert_template 'users/new'
    assert_select 'div.alert_danger'

  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         landscape: "Mars",
                                         location: "Venus",
                                         email: "user@example.com",
                                         password: "password123",
                                         password_confirmation: "password123",
                                         terms_of_service: "1" } }
    end
    follow_redirect!
    assert_template '/'
    assert is_logged_in?
    assert_not flash.empty?
  end

  test "valid signup, but user agreement not agreed upon" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "Example User",
                                         landscape: "Mars",
                                         location: "Venus",
                                         email: "user@example.com",
                                         password: "password9000",
                              password_confirmation: "password9000", terms_of_service: "0" } }
    end
    assert_template 'users/new'
    assert_select 'div.alert_danger'
  end
end
