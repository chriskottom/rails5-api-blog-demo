require 'test_helper'
require 'json'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'should get valid list of users' do
    get users_url

    assert_response :success
    assert_equal response.content_type, 'application/vnd.api+json'
    assert_equal 6, response_data['data'].length
    assert_equal response_data['data'][0]['type'], 'users'
  end

  test 'should get valid user data' do
    user = users(:user_1)
    get user_url(user)

    assert_response :success
    assert_equal user.id.to_s, response_data.dig('data', 'id')
    assert_equal user.full_name, response_data.dig('data', 'attributes', 'full-name')
    assert_equal user_url(user), response_data.dig('data', 'links', 'self')
  end

  test 'should get JSON:API error block when requesting user data with invalid ID' do
    get user_url('ZZZ')

    assert_response :missing
    assert_equal 'Wrong ID provided', response_data['errors'][0]['detail']
    assert_equal '/data/attributes/id', response_data['errors'][0]['source']['pointer']
  end

  test 'cannot create a new user without sending the correct content type' do
    post users_url
    assert_response 406
  end

  test 'cannot create a new user without sending the API key' do
    post users_url, headers: { 'Content-Type' => 'application/vnd.api+json' }
    assert_response 403
  end

  test 'cannot create a new user with a bad API key' do
    post users_url, headers: { 'Content-Type' => 'application/vnd.api+json',
                               'X-Api-Key' => 'XXXX' }
    assert_response 403
  end

  test 'cannot create a new user with an invalid type in JSON data' do
    user = users(:user_1)
    post users_url,
         headers: { 'Content-Type' => 'application/vnd.api+json',
                    'X-Api-Key' => user.token },
         params: { data: { type: 'posts' } },
         as: :json
    assert_response 409
  end

  test 'cannot create a new user with invalid data' do
    user = users(:user_1)
    post users_url,
         headers: { 'Content-Type' => 'application/vnd.api+json',
                    'X-Api-Key' => user.token },
         params: {
           data: {
             type: 'users',
             attributes: {
               full_name: nil,
               password: nil,
               password_confirmation: nil
             }
           }
         },
         as: :json

    assert_response 422
    pointers = response_data['errors'].collect { |e|
      e.dig('source', 'pointer').split('/').last
    }.sort
    assert_equal ['full-name', 'password'], pointers
  end

  test 'should create new user when headers and data are valid' do
    user = users(:user_1)
    post users_url,
         headers: { 'Content-Type' => 'application/vnd.api+json',
                    'X-Api-Key' => user.token },
         params: {
           data: {
             type: 'users',
             attributes: {
               full_name: 'User #7',
               password: 'secret',
               password_confirmation: 'secret'
             }
           }
         },
         as: :json

    assert_response 201
    assert_equal 'User #7', response_data.dig('data', 'attributes', 'full-name')
  end

  test 'should update an existing user with valid data' do
    user = users(:user_1)
    patch user_url(user),
         headers: { 'Content-Type' => 'application/vnd.api+json',
                    'X-Api-Key' => user.token },
         params: {
           data: {
             type: 'users',
             attributes: {
               full_name: 'User #1a'
             }
           }
         },
         as: :json

    assert_response :success
    assert_equal 'User #1a', response_data.dig('data', 'attributes', 'full-name')
  end

  test 'should delete a user' do
    authenticated_user = users(:user_1)
    user_to_be_deleted = users(:user_2)
    user_count         = User.count

    delete user_url(user_to_be_deleted),
           headers: { 'Content-Type' => 'application/vnd.api+json',
                      'X-Api-Key' => authenticated_user.token }

    assert_response 204
    assert_equal user_count - 1, User.count
  end
end
