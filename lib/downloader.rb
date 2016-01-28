class Downloader
  DOWNLOADER_LOG = Logger.new(File.join(Rails.root, 'log', 'downloader.log'))

  def self.download(url)
    response = HTTParty.get(url); nil

    if response.code == 200
      response.body
    else
      DOWNLOADER_LOG.error "Can't download #{url}. Error code: #{response.code}"
      nil
    end

  rescue StandardError => e

    DOWNLOADER_LOG.error "Invalid URL. Error: #{e.message}"
    nil

  end
end
