require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    user = User.new(name: "Test User", balance: 100.0)
    assert user.valid?
  end

  test "should not be valid without a name" do
    user = User.new(balance: 100.0)
    assert_not user.valid?, "User should not be valid without a name"
  end

  test "should not be valid with negative balance" do
    user = User.new(name: "Test User", balance: -10.0)
    assert_not user.valid?, "User should not be valid with negative balance"
  end

  test "should have many borrow records" do
    user = User.create(name: "Test User", balance: 100.0)
    book = BookItem.create(title: "Test Book", stock_quantity: 5)
    borrow_record = BorrowRecord.create(user: user, book_item: book, fee: 5.0)
    
    assert_includes user.borrow_records, borrow_record
  end

  test "current_book_items should return only unreturned books" do
    user = User.create(name: "Test User", balance: 100.0)
    book1 = BookItem.create(title: "Book 1", stock_quantity: 5)
    book2 = BookItem.create(title: "Book 2", stock_quantity: 5)
    
    BorrowRecord.create(user: user, book_item: book1, fee: 5.0, returned: false)
    BorrowRecord.create(user: user, book_item: book2, fee: 5.0, returned: true)
    
    assert_includes user.current_book_items, book1
    assert_not_includes user.current_book_items, book2
  end
end