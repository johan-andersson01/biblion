require 'test_helper'

class BookTest < ActiveSupport::TestCase
  def setup
    @owner = User.new(name: "example user",
    email: "user@example.com", location: "Venus", landscape: "Mars",
    password: "foobar9000", password_confirmation: "foobar9000", terms_of_service: true)
    @owner.save!

    @book = Book.new(
      title: "Harry Potter",
      author: "J.K. Rowling",
      year: 2018,
      description: "I love harry potter",
      user_id: @owner.id,
      language: "Svenska",
      pages: 444,
      quality: "Använd",
      genre: "Skönlitteratur",
      comment: "DÅligt skick",
      tags: "magi, fantasy"
    )
    @book.save!
  end

  test 'language' do
    dup_book = @book.dup
    dup_book.language = 'en'
    dup_book.save

    assert_equal 'Engelska', dup_book.language

    dup_book.language = 'engelska'
    dup_book.save

    assert_equal 'Engelska', dup_book.language
  end

  test "search_title" do
    sub1 = Book.search("Harry").first
    sub2 = Book.search("Potter").first
    whole = Book.search("Harry Potter").first
    assert_not_nil(sub1)
    assert_not_nil(sub2)
    assert_not_nil(whole)
    assert_equal(sub1.title, sub2.title)
    assert_equal(sub2.title, whole.title)
  end

  test "search_author" do
    sub1 = Book.search("Rowli").first
    sub2 = Book.search("J.K.").first
    whole = Book.search("J.K. Rowling").first
    wrong = Book.search("Nonexisting author").first
    assert_not_nil(sub1)
    assert_not_nil(sub2)
    assert_not_nil(whole)
    assert_nil(wrong)
    assert_equal(sub1.id, sub2.id)
    assert_equal(sub2.id, whole.id)
  end

  test "search_tags" do
    sub1 = Book.search("magi").first
    sub2 = Book.search("fantasy").first
    wrong = Book.search("asd").first
    assert_not_nil(sub1)
    assert_not_nil(sub2)
    assert_nil(wrong)
    assert_equal(sub1.id, sub2.id)
  end

  test "search_genre" do
    sub1 = Book.search("Skönlitteratur").first
    sub2 = Book.search("Skönlitt").first
    wrong = Book.search("asd").first
    assert_not_nil(sub1)
    assert_not_nil(sub2)
    assert_nil(wrong)
    assert_equal(sub1.id, sub2.id)
  end


end
