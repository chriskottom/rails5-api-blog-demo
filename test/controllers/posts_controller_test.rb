require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  test 'should get valid list of posts' do
    get posts_url, params: { page: { number: 2 } }

    assert_response :success
    assert_equal response.content_type, 'application/vnd.api+json'
    assert_equal Post.default_per_page, response_data['data'].length
    assert_equal response_data['data'][0]['type'], 'posts'

    links = response_data['links']
    assert_equal links['first'], links['prev']
    assert_equal links['last'], links['next']

    meta = response_data['meta']
    assert_equal Post.count, meta['total-count']
  end

  test 'should sort lists on request' do
    post = Post.order('rating DESC').first
    get posts_url, params: { sort: '-rating' }

    assert_response :success
    assert_equal post.title, response_data['data'][0]['attributes']['title']
  end

  test 'should filter lists on request' do
    get posts_url, params: { filter: 'First' }

    assert_response :success
    assert_equal Post.where(category: 'First').count, response_data['data'].length
  end
end
