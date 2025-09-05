require 'test_helper'

class Api::V1::BookItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @book_item = BookItem.create!(title: "Test Book", stock_quantity: 5)
    @book_params = { book_item: { title: "New Book", stock_quantity: 10 } }
  end

  test "should get index" do
    get api_v1_book_items_url, as: :json
    assert_response :success
    assert_not_empty JSON.parse(response.body)
  end

  test "should get show" do
    get api_v1_book_item_url(@book_item), as: :json
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal @book_item.title, json_response['title']
  end

  test "should create book_item" do
    assert_difference('BookItem.count') do
      post api_v1_book_items_url, params: @book_params, as: :json
    end

    assert_response :created
  end

  test "should update book_item" do
    patch api_v1_book_item_url(@book_item), params: { book_item: { title: "Updated Title" } }, as: :json
    assert_response :success
    
    @book_item.reload
    assert_equal "Updated Title", @book_item.title
  end

  test "should destroy book_item" do
    assert_difference('BookItem.count', -1) do
      delete api_v1_book_item_url(@book_item), as: :json
    end

    assert_response :success
  end
end