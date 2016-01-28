require 'zip'

class Extractor

  def self.extract_first_csv(stream)
    csv = nil

    Zip::InputStream.open(StringIO.new(stream)) do |io|
      while entry = io.get_next_entry
        if entry.name.downcase.include?('.csv')
          csv = io.read
          break
        end
      end
    end

    csv
  end
end
