require 'test_helper'

class GetCountryByIpTest < ActionDispatch::IntegrationTest

  test 'should get country by ip' do
    get '/api/country_by_ip?ip=94.125.52.11'
    assert_response :success
    assert_includes @response.body, 'Russia'
  end

  test 'should render not found if not found country by ip' do
    ip = '105.125.52.11'
    get "/api/country_by_ip?ip=#{ip}"
    assert_response :missing
    assert_includes @response.body, ip
  end


  test 'should render error if get without params' do
    get '/api/country_by_ip'
    assert_response :error
    assert_includes @response.body, 'error'
  end

end
