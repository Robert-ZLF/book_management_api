require 'test_helper'

class BookItemTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    book = BookItem.new(title: "Test Book", stock_quantity: 5, borrow_count: 0)
    assert book.valid?
  end

  test "should not be valid without a title" do
    book = BookItem.new(stock_quantity: 5)
    assert_not book.valid?, "Book should not be valid without a title"
  end

  test "should not be valid with negative stock" do
    book = BookItem.new(title: "Test Book", stock_quantity: -1)
    assert_not book.valid?, "Book should not be valid with negative stock"
  end

  test "should not be valid with negative borrow count" do
    book = BookItem.new(title: "Test Book", stock_quantity: 5, borrow_count: -1)
    assert_not book.valid?, "Book should not be valid with negative borrow count"
  end

  test "should have default borrow_count of 0" do
    book = BookItem.new(title: "Test Book", stock_quantity: 5)
    assert_equal 0, book.borrow_count
  end

  test "should have many borrow records" do
    book = BookItem.create(title: "Test Book", stock_quantity: 5)
    user = User.create(name: "Test User", balance: 100.0)
    borrow_record = BorrowRecord.create(user: user, book_item: book, fee: 5.0)
    
    assert_includes book.borrow_records, borrow_record
  end
end