require 'test_helper'

class DownloaderTest < ActiveSupport::TestCase
  test 'download file with valid url if file exists' do
    url = 'http://download.ip2location.com/lite/IP2LOCATION-LITE-DB1.CSV.ZIP'
    result = Downloader.download(url)
    assert_kind_of String, result
  end

  test 'return nil for url without success (200) answer' do
    url = 'http://download.ip2location.com/lite/IP2LOCATION-LITE-DB1.CSV.ZIP.broken'
    result = Downloader.download(url)
    assert_nil result
  end

  test 'return error message for invalid url' do
    url = 'http://invalid.url'
    result = Downloader.download(url)
    assert_nil result
  end
end
