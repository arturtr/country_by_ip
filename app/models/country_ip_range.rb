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

class CountryIpRange < ApplicationRecord
  validates_presence_of :country_name, :from_ip, :to_ip
end
