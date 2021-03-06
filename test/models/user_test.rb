require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "example user",
    email: "user@example.com", location: "Venus", landscape: "Mars",
    password: "foobar9000", password_confirmation: "foobar9000", terms_of_service: true)
    @user.save
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "   "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "   "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "name should not be too short" do
    @user.name = "a" * 1
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email should not be too short" do
    @user.email = "a@by"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
   valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                        first.last@foo.jp alice+bob@baz.cn]
   valid_addresses.each do |valid_address|
     @user.email = valid_address
     assert @user.valid?, "#{valid_address.inspect} should be valid"
   end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                         foo@bar_baz.com foo@bar+baz.com foo@bar..com foo@.bar.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email should be saved as lower-case" do
    mixed_case_email = "FoO@ExAmPlE.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "passwords should not be blank" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "passwords should have min length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated books should be destroyed" do
  @user.save
  @user.books.create!(title: "This is the title", author: "Example author", quality: "Använd",
  genre: "Skönlitteratur", language: "svenska", description: "Lorem ipsum")
  assert_difference 'Book.count', -1 do
    @user.destroy
  end
end

end
