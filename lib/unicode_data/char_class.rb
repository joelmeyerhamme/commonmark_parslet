require 'csv'

module UnicodeData
  DATA ||= CSV.parse(File.read("./lib/unicode_data/unicode_data.csv"), {:col_sep => ';'})

  module CharClass
    CLASSES ||= DATA.group_by { |char| char[2] }

    def self.[](*cl)
      cl.map do |c|
        CLASSES[c].map { |r| r.first }
      end.flatten
    end
  end
end
