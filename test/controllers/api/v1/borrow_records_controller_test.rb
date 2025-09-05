require 'test_helper'

class Api::V1::BorrowRecordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(name: "Borrower", balance: 100.0)
    @book = BookItem.create!(title: "Borrow Book", stock_quantity: 5)
    @borrow_params = { user_id: @user.id, book_item_id: @book.id, fee: 5.0 }
  end

  test "should borrow book successfully" do
    # 检查库存变化
    assert_difference('@book.reload.stock_quantity', -1) do
      assert_difference('@book.reload.borrow_count', 1) do
        post api_v1_borrow_url, params: @borrow_params, as: :json
      end
    end
    assert_response :ok
    assert_not_empty BorrowRecord.where(user: @user, book_item: @book, returned: false)
  end

  test "should not borrow book with no stock" do
    # 先把库存减到0
    @book.update!(stock_quantity: 0)
    
    post api_v1_borrow_url, params: @borrow_params, as: :json
    assert_response :bad_request
  end

  test "should not borrow book if user already borrowed" do
    # 先创建一条未归还记录
    BorrowRecord.create!(user: @user, book_item: @book, fee: 5.0, returned: false)
    
    post api_v1_borrow_url, params: @borrow_params, as: :json
    assert_response :bad_request
  end

  test "should return book successfully" do
    # 先创建借阅记录
    borrow_record = BorrowRecord.create!(user: @user, book_item: @book, fee: 5.0, returned: false)
    return_params = { user_id: @user.id, book_item_id: @book.id }
    
    # 检查库存和余额变化
    assert_difference('@book.reload.stock_quantity', 1) do
      assert_difference('@user.reload.balance', -5.0) do
        post api_v1_return_url, params: return_params, as: :json
      end
    end
    
    assert_response :ok
    assert borrow_record.reload.returned
  end

  test "should not return book with insufficient balance" do
    # 创建借阅记录但设置用户余额不足
    @user.update!(balance: 2.0)
    BorrowRecord.create!(user: @user, book_item: @book, fee: 5.0, returned: false)
    return_params = { user_id: @user.id, book_item_id: @book.id }
    
    post api_v1_return_url, params: return_params, as: :json
    assert_response :bad_request
  end
end