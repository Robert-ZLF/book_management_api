require 'test_helper'

class Api::V1::UserReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(name: "Report User", balance: 200.0)
    @book = BookItem.create!(title: "Report Book", stock_quantity: 10)
    
    @jan_record = BorrowRecord.create!(
      user: @user,
      book_item: @book,
      fee: 5.0,
      returned: true,
      return_date: Date.new(2024, 1, 15)
    )
    
    @feb_record = BorrowRecord.create!(
      user: @user,
      book_item: @book,
      fee: 7.0,
      returned: true,
      return_date: Date.new(2024, 2, 20)
    )
    
    @record_2023 = BorrowRecord.create!(
      user: @user,
      book_item: @book,
      fee: 10.0,
      returned: true,
      return_date: Date.new(2023, 12, 30)
    )
    
    @unreturned_record = BorrowRecord.create!(
      user: @user,
      book_item: @book,
      fee: 15.0,
      returned: false,
      return_date: nil
    )
  end

  test "should get monthly report with correct data" do

    url = "/api/v1/users/#{@user.id}/reports/monthly"
    get url, params: { year: 2024, month: 1 }
    assert_response :ok
    json = JSON.parse(response.body)

    assert_equal @user.id, json['user_id']
    assert_equal 'monthly', json['report_type']
    assert_equal 2024, json['year']
    assert_equal 1, json['month']
    assert_equal 1, json['total_books_borrowed']
    assert_equal "5.0", json['total_spent']
  end

  test "should return empty monthly report when no records" do
    url = "/api/v1/users/#{@user.id}/reports/monthly"
    get url, params: { year: 2024, month: 3 }

    assert_response :ok
    json = JSON.parse(response.body)
    assert_equal 0, json['total_books_borrowed']
    assert_equal "0.0", json['total_spent']
  end

  test "should return error for invalid monthly report parameters" do
    url = "/api/v1/users/#{@user.id}/reports/monthly"
    
    # 缺少年份
    get url, params: { month: 1 }
    assert_response :bad_request

    # 缺少月份
    get url, params: { year: 2024 }

    assert_response :bad_request

    # 无效月份
    get url, params: { year: 2024, month: 13 }

    assert_response :bad_request
  end

  # 年度报表：URL 必须是 /api/v1/users/[user_id]/reports/yearly
  test "should get yearly report with correct data" do
    url = "/api/v1/users/#{@user.id}/reports/yearly"
    get url, params: { year: 2024 }

    assert_response :ok
    json = JSON.parse(response.body)
    
    assert_equal @user.id, json['user_id']
    assert_equal 'yearly', json['report_type']
    assert_equal 2024, json['year']
    assert_equal 2, json['total_books_borrowed']
    assert_equal "12.0", json['total_spent']
  end

  test "should return empty yearly report when no records" do
    url = "/api/v1/users/#{@user.id}/reports/yearly"
    get url, params: { year: 2022 }

    assert_response :ok
    json = JSON.parse(response.body)
    
    assert_equal 0, json['total_books_borrowed']
    assert_equal "0.0", json['total_spent']
  end

  test "should return error for invalid yearly report parameters" do
    url = "/api/v1/users/#{@user.id}/reports/yearly"
    get url, params: {}

    assert_response :bad_request
  end

  test "should return not found for non-existent user" do
    # 不存在的 user_id=9999，URL 格式仍需正确
    monthly_url = "/api/v1/users/9999/reports/monthly"
    get monthly_url, params: { year: 2024, month: 1 }
    assert_response :not_found
    
    yearly_url = "/api/v1/users/9999/reports/yearly"
    get yearly_url, params: { year: 2024 }
    assert_response :not_found
  end

  test "should not include unreturned records in reports" do
    monthly_url = "/api/v1/users/#{@user.id}/reports/monthly"
    get monthly_url, params: { year: 2024, month: 1 }
    json_monthly = JSON.parse(response.body)
    assert_equal 1, json_monthly['total_books_borrowed']

    yearly_url = "/api/v1/users/#{@user.id}/reports/yearly"
    get yearly_url, params: { year: 2024 }
    json_yearly = JSON.parse(response.body)
    assert_equal 2, json_yearly['total_books_borrowed']
  end
end