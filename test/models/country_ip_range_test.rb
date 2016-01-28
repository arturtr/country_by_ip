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
      from_ip: '78.0.0.0',
      to_ip: '78.0.255.255',
      country_name: 'Russia',
      country_short_name: 'RU'
    }
  end

  test 'should be save with valid attributes' do
    country_ip_range = CountryIpRange.new(valid_attributes)
    assert country_ip_range.save
  end

  test 'should be valid without country short name' do
    country_ip_range = CountryIpRange.new(valid_attributes.except(:country_short_name))
    assert country_ip_range.valid?
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

  test 'find country by ip' do
    russia_ip_range = country_ip_ranges(:russia)
    country = CountryIpRange.find_country_by_ip('94.125.52.36')
    assert_equal country, 'Russia'
    assert_equal country, russia_ip_range.country_name
  end

  test 'return nil if country not found' do
    country = CountryIpRange.find_country_by_ip('99.125.52.36')
    assert_nil country
  end

  test 'sync create new range' do
    assert_difference('CountryIpRange.count') do
      CountryIpRange.sync(valid_attributes[:from_ip],
                          valid_attributes[:to_ip],
                          valid_attributes[:country_name],
                          valid_attributes[:country_short_name])
    end
    country_ip_range = CountryIpRange.last

    assert_equal country_ip_range.from_ip, valid_attributes[:from_ip]
    assert_equal country_ip_range.to_ip, valid_attributes[:to_ip]
    assert_equal country_ip_range.country_name, valid_attributes[:country_name]
    assert_equal country_ip_range.country_short_name, valid_attributes[:country_short_name]
  end

  test 'sync update existed range' do
    malta_ip_range = country_ip_ranges(:malta)
    old_malta_ip_range = malta_ip_range.attributes.symbolize_keys

    assert_difference('CountryIpRange.count', 0) do
      CountryIpRange.sync(malta_ip_range[:from_ip],
                          malta_ip_range[:to_ip],
                          valid_attributes[:country_name],
                          valid_attributes[:country_short_name])
    end

    malta_ip_range.reload

    assert_equal malta_ip_range.from_ip, old_malta_ip_range[:from_ip]
    assert_equal malta_ip_range.to_ip, old_malta_ip_range[:to_ip]

    assert_equal malta_ip_range.country_name, valid_attributes[:country_name]
    assert_equal malta_ip_range.country_short_name, valid_attributes[:country_short_name]

    assert_not_equal malta_ip_range.country_name, old_malta_ip_range[:country_name]
    assert_not_equal malta_ip_range.country_short_name, old_malta_ip_range[:country_short_name]

  end

  test 'sync for extended range' do
    russia_ip_range = country_ip_ranges(:russia)
    old_russia_ip_range = russia_ip_range.attributes.symbolize_keys
    malta_ip_range = country_ip_ranges(:malta)
    old_malta_ip_range = malta_ip_range.attributes.symbolize_keys

    assert_difference('CountryIpRange.count', -1) do
      @new_russia_ip_range = CountryIpRange.sync(russia_ip_range[:from_ip],
                                                 malta_ip_range[:to_ip],
                                                 russia_ip_range[:country_name],
                                                 russia_ip_range[:country_short_name])
    end


    assert_equal @new_russia_ip_range.from_ip, old_russia_ip_range[:from_ip]
    assert_equal @new_russia_ip_range.to_ip, old_malta_ip_range[:to_ip]

    assert_equal @new_russia_ip_range.country_name, old_russia_ip_range[:country_name]
    assert_equal @new_russia_ip_range.country_short_name, old_russia_ip_range[:country_short_name]

  end

  test 'sync for narrowed range' do
    malta_ip_range = country_ip_ranges(:malta)
    old_malta_ip_range = malta_ip_range.attributes.symbolize_keys

    narrowed_right_border = malta_ip_range[:to_ip].to_s.gsub('255', '128')

    assert_difference('CountryIpRange.count', 0) do
      CountryIpRange.sync(malta_ip_range[:from_ip],
                          narrowed_right_border,
                          valid_attributes[:country_name],
                          valid_attributes[:country_short_name])
    end

    malta_ip_range.reload

    assert_equal malta_ip_range.from_ip, old_malta_ip_range[:from_ip]
    assert_equal malta_ip_range.to_ip, narrowed_right_border

    assert_equal malta_ip_range.country_name, valid_attributes[:country_name]
    assert_equal malta_ip_range.country_short_name, valid_attributes[:country_short_name]

    assert_not_equal malta_ip_range.country_name, old_malta_ip_range[:country_name]
    assert_not_equal malta_ip_range.country_short_name, old_malta_ip_range[:country_short_name]
  end
end
