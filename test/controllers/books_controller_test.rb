require 'test_helper'

class BooksControllerTest < ActionDispatch::IntegrationTest

  def setup
    @book_one = books(:one)
    @book_two = books(:two)
    @admin = users(:admin)
    @user = users(:michael)
    @other_user = users(:archer)
    @user_book = Book.new(
      title: "Harry Potter",
      author: "J.K. Rowling",
      year: 2018,
      description: "I love harry potter",
      user_id: @user.id,
      language: "Svenska",
      pages: 444,
      quality: "Använd",
      genre: "Skönlitteratur",
      comment: "DÅligt skick",
      tags: "magi, fantasy"
      )
    @user_book.save!
    @book_outside_db = Book.new(
      id: 123,
      title: "Harry Slotter",
      author: "J.K. Fowling",
      year: 2018,
      description: "I hate harry potter",
      user_id: @user.id,
      language: "Svenska",
      pages: 444,
      quality: "Använd",
      genre: "Skönlitteratur",
      comment: "DÅligt skick",
      tags: "magi, fantasy"
    )

    @unactivated = User.new(name: "example user", activated: false, disabled: false,
    email: "user@example.com", location: "Venus", landscape: "Mars",
    password: "foobar9000", password_confirmation: "foobar9000", terms_of_service: true)
    @unactivated.save!
  end

  class New < ActionDispatch::IntegrationTest
    test 'GET new_book_path when not logged in' do
      get new_book_path
      
      assert_redirected_to login_path
    end

    test "GET new_book_path when logged in" do
      log_in_as users :michael
      get new_book_path

      assert_response :success
    end
  end

  class Show < ActionDispatch::IntegrationTest
    test "GET book_path with valid book" do
      get book_path books :one

      assert_response :success
    end

    test 'GET book_path with invalid book' do
      get book_path 0

      assert_redirected_to root_url
    end
  end

  class Edit < ActionDispatch::IntegrationTest
    test 'GET edit_book_path when not logged in' do
      get edit_book_path books :one

      assert_redirected_to login_path
    end

    test 'Get edit_book_path when logged in and is the book owner' do
      user = users :michael
      # We should use factories to create these records.
      book = user.books.create!(author: 'xxxx', title: 'xx', quality: 'x', genre: 'x', language: 'x')
      log_in_as user
      get edit_book_path book

      assert_response :success
    end

    test 'GET edit_book_path when logged in with invalid book' do
      log_in_as users :michael
      get edit_book_path 0

      assert_redirected_to root_path
    end

    test 'GET edit_book_path when logged in and is not the book owner' do
      log_in_as users :michael
      get edit_book_path books :one

      assert_redirected_to root_path
    end

    test 'GET edit_book_path when logged in as admin' do
      log_in_as_admin users :admin
      get edit_book_path books :one

      assert_response :success
    end
  end

  test "should redirect update when not logged in" do
    prev_title = @user_book.title
    patch book_path(@user_book), params: { book: {title: "Hacked title"}}
    assert_redirected_to root_url
    assert_equal(prev_title, @user_book.title)
    assert_equal(@user_book.reload.title, prev_title)
    log_in_as(@user)
    patch book_path(@user_book), params: { book: {title: "Legit title"}}
    assert_not flash[:success].empty?
    assert_redirected_to book_path(@user_book)
    assert_equal(@user_book.reload.title, "Legit title")
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch book_path(@user_book), params: { book: {title: "Hacked title"}}
    assert_response :redirect
    assert_redirected_to root_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Book.count' do
      delete book_path(@user_book)
    end
    assert_redirected_to root_url
  end

  test "should redirect destroy when logged in as wrong user" do
    log_in_as(@other_user)
    assert_no_difference 'Book.count' do
      delete book_path(@user_book)
    end
    assert_redirected_to root_url
  end

  test "should destroy when logged in as user" do
    log_in_as(@user)
    assert_difference 'Book.count', -1 do
      delete book_path(@user_book)
    end
    assert_redirected_to root_url
  end

  test "should destroy when logged in as admin" do
    log_in_as_admin(@admin)
    assert_difference 'Book.count', -1 do
      delete book_path(@user_book)
    end
    assert_redirected_to root_url
  end

  test "should not create a book since not logged in" do
    assert_no_difference 'Book.count' do
      post new_book_url({book: {
                title: "Harry Slotter",
                cover: "sample-url.org",
                author: "J.K. Fowling",
                year: 2018,
                description: "I hate harry potter",
                user_id: @user.id,
                language: "Svenska",
                pages: 444,
                quality: "Använd",
                genre: "Skönlitteratur",
                comment: "DÅligt skick",
                tags: "magi, fantasy"}})
    end
  end

  test "should create a book" do
    log_in_as(@user)
    assert_difference 'Book.count', 1 do
      post new_book_url({book: {
                title: "Harry Slotter",
                cover: "sample-url.org",
                author: "J.K. Fowling",
                year: 2018,
                description: "I hate harry potter",
                user_id: @user.id,
                language: "sv",
                pages: 444,
                quality: "Använd",
                genre: "Skönlitteratur",
                comment: "DÅligt skick",
                tags: "magi, fantasy"}})
    end
  end

  test "get author page" do
    get author_url({author: "Rowling"})
    assert_response :success
  end

  test "get landscape page" do
    get landscape_url({landscape: "venus"})
    assert_response :success
  end

  test "get location page" do
    get location_url({location: "mars"})
    assert_response :success
  end

  test "get tag page" do
    get tag_url({tags: "fantasy"})
    assert_response :success
  end

  test "get genre page" do
    log_in_as(@user)
    get genre_url({genre: "Rowling"})
    assert_response :success
  end

  test "search for book" do
    get search_url({book: {query: "fantasy"}})
    assert_redirected_to root_url
    post search_url({book: {query: "fantasy"}})
    assert_response :success
  end

  test "should not be able to reach add book without login" do 
    get url_for(action: 'add', controller: 'books')
    assert_redirected_to login_url
  end

  test "should show matching books from google" do 
    log_in_as(@user)
    get books_add_path
    assert_response :success
    assert_select ".books", 0

    post books_add_path({book: {query: "dune"}})
    assert_response :success
    assert_template :add
    assert_select ".books" do |e|
      assert_select e, "li", 30
    end
  end

  test "disabled users should not be able to create books" do
    log_in_as_admin(@admin)
    patch user_path(@user), params: { user: { disabled: true, oldpassword: "foobar9000" } }
    assert @user.reload.disabled?
    log_in_as(@user)
    assert_no_difference 'Book.count' do
      post new_book_url({book: {
                title: "Harry Slotter",
                cover: "sample-url.org",
                author: "J.K. Fowling",
                year: 2018,
                description: "I hate harry potter",
                user_id: @user.id,
                language: "sv",
                pages: 444,
                quality: "Använd",
                genre: "Skönlitteratur",
                comment: "DÅligt skick",
                tags: "magi, fantasy"}})
    end
  end

  test "unactivated users should not be able to create books" do
    assert_not @unactivated.activated?
    log_in_as(@unactivated)
    assert_no_difference 'Book.count' do
      post new_book_url({book: {
                title: "Harry Slotter",
                cover: "sample-url.org",
                author: "J.K. Fowling",
                year: 2018,
                description: "I hate harry potter",
                user_id: @unactivated.id,
                language: "sv",
                pages: 444,
                quality: "Använd",
                genre: "Skönlitteratur",
                comment: "DÅligt skick",
                tags: "magi, fantasy"}})
    end
  end



end
