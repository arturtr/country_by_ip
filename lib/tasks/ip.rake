# require 'open-uri'

namespace :ip do
  task :sync => :environment do
    %w( http://download.ip2location.com/lite/IP2LOCATION-LITE-DB1.CSV.ZIP
        http://download.ip2location.com/lite/IP2LOCATION-LITE-DB1.IPV6.CSV.ZIP).each do |remote_url|
      input = Downloader.download(remote_url)

      if input.present?

        csv = Extractor.extract_first_csv(input)

        Parser.parse(csv) if csv.present?

      end

    end


  end
end
