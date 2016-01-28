require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  test 'should get root' do
    get root_url
    assert_response :success
    assert_includes @response.body, 'hello'
  end

end
