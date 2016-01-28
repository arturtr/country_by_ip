require 'test_helper'

class ParserTest < ActiveSupport::TestCase
  test 'parse csv row with zero begin for IPv4' do
    csv = '"0","16777471","AU","Australia"'

    assert_difference('CountryIpRange.count') do
      Parser.parse(csv)
    end

    country_ip_range = CountryIpRange.last

    assert_equal country_ip_range.from_ip, '0.0.0.0'
    assert_equal country_ip_range.to_ip, '1.0.0.255'
    assert_equal country_ip_range.country_short_name, 'AU'
    assert_equal country_ip_range.country_name, 'Australia'
  end

  test 'parse valid csv row for IPv4' do
    csv = '"16777216","16777471","AU","Australia"'

    assert_difference('CountryIpRange.count') do
      Parser.parse(csv)
    end

    country_ip_range = CountryIpRange.last

    assert_equal country_ip_range.from_ip, '1.0.0.0'
    assert_equal country_ip_range.to_ip, '1.0.0.255'
    assert_equal country_ip_range.country_short_name, 'AU'
    assert_equal country_ip_range.country_name, 'Australia'
  end

  test 'parse valid csv row for IPv6' do
    csv = '"281470698520832","281470698521599","CN","China"'

    assert_difference('CountryIpRange.count') do
      Parser.parse(csv)
    end

    country_ip_range = CountryIpRange.last

    assert_equal country_ip_range.from_ip, '::ffff:1.0.1.0'
    assert_equal country_ip_range.to_ip, '::ffff:1.0.3.255'
    assert_equal country_ip_range.country_short_name, 'CN'
    assert_equal country_ip_range.country_name, 'China'
  end


  test 'parse csv row with invalid data' do
    csv = 'invalid data'

    assert_difference('CountryIpRange.count', 0) do
      Parser.parse(csv)
    end

  end

end
