# == Schema Information
#
# Table name: country_ip_ranges
#
#  id                 :integer          not null, primary key
#  country_name       :string           not null
#  country_short_name :string
#  from_ip            :inet             not null
#  to_ip              :inet             not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_country_ip_ranges_on_from_ip_and_to_ip  (from_ip,to_ip)
#  index_country_ip_ranges_on_to_ip              (to_ip)
#

class CountryIpRange < ApplicationRecord
  validates_presence_of :country_name, :from_ip, :to_ip

  def self.find_country_by_ip(ip)
    where('from_ip <= :ip AND :ip <= to_ip', ip: ip).first.try(:country_name)
  end

  def self.sync(from_ip, to_ip, country_name, country_short_name)

    old_ranges = where(from_ip: from_ip).or(where(to_ip: to_ip)).to_a

    if old_ranges.present?
      first_old_range = old_ranges.pop
      first_old_range.update(from_ip: from_ip,
                             to_ip: to_ip,
                             country_short_name: country_short_name,
                             country_name: country_name)

      where(id: old_ranges.map(&:id)).destroy_all if old_ranges.present?

      first_old_range
    else
      create(from_ip: from_ip,
             to_ip: to_ip,
             country_short_name: country_short_name,
             country_name: country_name)
    end
  end
end
