# == Schema Information
#
# Table name: country_ip_ranges
#
#  id                 :integer          not null, primary key
#  country_name       :string           not null
#  short_country_name :string
#  from_ip            :inet             not null
#  to_ip              :inet             not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_country_ip_ranges_on_from_ip_and_to_ip  (from_ip,to_ip)
#

require 'test_helper'

class CountryIpRangeTest < ActiveSupport::TestCase
  def valid_attributes
    {
      country_name: 'Russia',
      from_ip: '78.0.0.0',
      to_ip: '78.0.255.255'
    }
  end

  test 'should be save with valid attributes' do
    country_ip_range = CountryIpRange.new(valid_attributes)
    assert country_ip_range.save
  end

  test 'should be invalid without any attributes' do
    country_ip_range = CountryIpRange.new
    assert_not country_ip_range.valid?
  end

  test 'should be invalid without country name' do
    country_ip_range = CountryIpRange.new(valid_attributes.except(:country_name))
    assert_not country_ip_range.valid?
  end

  test 'should be invalid without any from IP' do
    country_ip_range = CountryIpRange.new(valid_attributes.except(:from_ip))
    assert_not country_ip_range.valid?
  end

  test 'should be invalid without any to IP' do
    country_ip_range = CountryIpRange.new(valid_attributes.except(:to_ip))
    assert_not country_ip_range.valid?
  end
end
