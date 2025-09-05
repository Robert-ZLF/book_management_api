require 'test_helper'

class Api::V1::BookStatisticsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @book = BookItem.create!(title: "Statistics Book", stock_quantity: 5)
    @user = User.create!(name: "Stats User", balance: 100.0)

    @returned_records = 3.times.map do
      BorrowRecord.create!(
        user: @user,
        book_item: @book,
        fee: 5.0,
        returned: true,
        return_date: Date.current - 2.days
      )
    end

    BorrowRecord.create!(
      user: @user,
      book_item: @book,
      fee: 5.0,
      returned: false,
      return_date: nil
    )
  end

  test "should get correct book income" do
    start_date = (Date.current - 3.days).to_s
    end_date = Date.current.to_s

    book_income_url = "/api/v1/book_items/#{@book.id}/income"

    get book_income_url, params: { start_date: start_date, end_date: end_date }

    assert_response :ok
    json_response = JSON.parse(response.body)

    assert_equal @book.id, json_response['book_item_id']
    assert_equal @book.title, json_response['book_title']
    assert_equal start_date, json_response['statistics_period']['start_date']
    assert_equal end_date, json_response['statistics_period']['end_date']

    assert_equal 15.0, json_response['total_income'].to_f
    assert_equal 3, json_response['record_count']
  end

  test "should return error for invalid date range" do

    book_income_url = "/api/v1/book_items/#{@book.id}/income"

    get book_income_url,params: { start_date: Date.current.to_s, end_date: (Date.current - 1.day).to_s }

    assert_response :bad_request
    json_response = JSON.parse(response.body)
    assert_equal "Start date cannot be later than end date", json_response['error']
  end

  test "should return error for non-existent book" do

    book_income_url = "/api/v1/book_items/9999/income"

    get book_income_url,
        params: { start_date: "2024-01-01", end_date: "2024-12-31" }

    assert_response :not_found
    json_response = JSON.parse(response.body)
    assert_equal "BookItem not found", json_response['error']
  end

  test "should return zero income when no valid records" do

    book_income_url = "/api/v1/book_items/#{@book.id}/income"

    get book_income_url,
      params: { start_date: (Date.current - 100.days).to_s, end_date: (Date.current - 90.days).to_s }

    assert_response :ok
    json_response = JSON.parse(response.body)

    assert_equal 0.0, json_response['total_income'].to_f
    assert_equal 0, json_response['record_count']
  end
end