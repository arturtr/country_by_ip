class Parser
  PARSER_LOG = Logger.new(File.join(Rails.root, 'log', 'parser.log'))

  def self.parse(csv)
    CSV.parse(csv) do |row|
      from_ip_int, to_ip_int, country_short_name, country_name = row

      if from_ip_int.present? and to_ip_int.present? and country_name.present?

        family = to_ip_int.to_s.size > 10 ? Socket::AF_INET6 : Socket::AF_INET

        from_ip = IPAddr.new(from_ip_int.to_i, family).to_s
        to_ip   = IPAddr.new(to_ip_int.to_i,   family).to_s

        CountryIpRange.sync(from_ip, to_ip, country_name, country_short_name)

      else
        PARSER_LOG.error "Invalid data row: #{row}"
      end
    end
  end
end
