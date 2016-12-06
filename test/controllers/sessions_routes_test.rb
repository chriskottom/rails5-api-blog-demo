require 'test_helper'

class SessionsRoutesTest < ActionDispatch::IntegrationTest
  test 'should route to create session' do
    assert_routing({ method: 'post', path: '/sessions' },
                   { controller: 'sessions', action: 'create' })
  end

  test 'should route to delete session' do
    assert_routing({ method: 'delete', path: '/sessions/fakeid' },
                   { controller: 'sessions', action: 'destroy', id: 'fakeid' })
  end
end
