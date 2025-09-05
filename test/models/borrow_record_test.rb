require 'test_helper'

class BorrowRecordTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    user = User.create(name: "Test User", balance: 100.0)
    book = BookItem.create(title: "Test Book", stock_quantity: 5)
    record = BorrowRecord.new(user: user, book_item: book, fee: 5.0)
    assert record.valid?
  end

  test "should not be valid with negative fee" do
    user = User.create(name: "Test User", balance: 100.0)
    book = BookItem.create(title: "Test Book", stock_quantity: 5)
    record = BorrowRecord.new(user: user, book_item: book, fee: -1.0)
    assert_not record.valid?, "Borrow record should not be valid with negative fee"
  end

  test "should have default returned status as false" do
    user = User.create(name: "Test User", balance: 100.0)
    book = BookItem.create(title: "Test Book", stock_quantity: 5)
    record = BorrowRecord.new(user: user, book_item: book, fee: 5.0)
    assert_not record.returned
  end

  test "should set default borrow date" do
    user = User.create(name: "Test User", balance: 100.0)
    book = BookItem.create(title: "Test Book", stock_quantity: 5)
    record = BorrowRecord.new(user: user, book_item: book, fee: 5.0)
    assert_not_nil record.borrow_date
  end
end