require 'test_helper'

class ExtractorTest < ActiveSupport::TestCase
  test 'extract csv from valid zip' do
    input = File.open(Rails.root.join 'test', 'fixtures', 'files', 'example_with_csv.zip').read
    result = Extractor.extract_first_csv(input)
    assert_kind_of String, result
  end

  test 'return nil for zip without csv' do
    input = File.open(Rails.root.join 'test', 'fixtures', 'files', 'example.yml.zip').read
    result = Extractor.extract_first_csv(input)
    assert_nil result
  end

  test 'return nil for not zip stream from file' do
    input = File.open(Rails.root.join 'test', 'fixtures', 'files', 'example.txt').read
    result = Extractor.extract_first_csv(input)
    assert_nil result
  end

  test 'return nil for not zip stream from string' do
    input = 'some string'
    result = Extractor.extract_first_csv(input)
    assert_nil result
  end


end
