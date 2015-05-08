require 'nata2'
require 'toml'

config_file = File.expand_path('config.toml', "#{__dir__}/../..")
sample_config_file = File.expand_path('config.sample.toml', "#{__dir__}/../..")
CONFIG = TOML.load_file(File.exist?(config_file) ? config_file : sample_config_file)

class Nata2::Config
  @@dburl = nil
  def self.get(keyword)
    case keyword
    when :dburl
      return @@dburl if @@dburl
      if ENV['RACK_ENV'] == 'test'
        require 'tempfile'
        temp = Tempfile.new('nata2test.db')
        @@dburl = %Q{sqlite://#{temp.path}}
      else
        @@dburl = CONFIG['dburl'] || 'sqlite://data/nata2.db'
      end
    else
      raise ArgumentError, "unknown configuration keyword: #{keyword}"
    end
  end
end
