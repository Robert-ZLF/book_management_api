require 'test_helper'

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_params = { user: { name: "Test User", balance: 100.0 } }
  end

  test "should create user" do
    assert_difference('User.count') do
      post api_v1_users_url, params: @user_params, as: :json
    end

    assert_response :created
    json_response = JSON.parse(response.body)
    assert_equal @user_params[:user][:name], json_response['name']
  end

  test "should not create user with invalid parameters" do
    assert_no_difference('User.count') do
      post api_v1_users_url, params: { user: { name: nil, balance: -10.0 } }, as: :json
    end

    assert_response :unprocessable_entity
  end

  test "should show user" do
    user = User.create! @user_params[:user]
    get api_v1_user_url(user), as: :json
    
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal user.id, json_response['user_id']
  end

  test "should return not found for show invalid user" do
    get api_v1_user_url(id: 9999), as: :json
    assert_response :not_found
  end
end