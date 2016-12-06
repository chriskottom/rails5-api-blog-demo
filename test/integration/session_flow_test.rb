require 'test_helper'

class SessionFlowTest < ActionDispatch::IntegrationTest
  test 'login timeout and meta/logged-in key test' do
    user = users(:user_5)

    # User not logged in because of timeout in fixture data
    get users_url, headers: { 'X-Api-Key' => user.token }
    assert_response :success
    assert_equal false, response_data.dig('meta', 'logged-in')

    # Log in
    post sign_in_url,
         as: :json,
         headers: { 'Content-Type' => 'application/vnd.api+json' },
         params: {
           data: {
             type: 'sessions',
             attributes: {
               full_name: user.full_name,
               password: 'password'
             }
           }
         }
    assert_response 201
    refute_equal user.token, response_data.dig('data', 'attributes', 'token')

    # Within session
    get users_url, headers: { 'X-Api-Key' => user.reload.token }
    assert_response :success
    assert_equal true, response_data.dig('meta', 'logged-in')
  end
end
