require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user_0)
  end

  test 'creating a new session with valid data creates a new session' do
    post sign_in_url,
         as: :json,
         headers: { 'Content-Type' => 'application/vnd.api+json' },
         params: {
           data: {
             type: 'sessions',
             attributes: {
               full_name: @user.full_name,
               password: 'password'
             }
           }
         }

    assert_response 201
    refute_equal @user.token, response_data.dig('data', 'attributes', 'token')
  end

  test 'should delete session' do
    delete sign_out_url(id: @user.token)
    assert_response 204
  end

  test 'should regenerate token on successful login' do
    original_token = @user.token
    delete sign_out_url(id: @user.token)
    refute_equal original_token, @user.reload.token
  end

  test 'should respond :not_found if token does not match' do
    delete sign_out_url(id: 'FOOOBAAR')
    assert_response :not_found
  end
end
