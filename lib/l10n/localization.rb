require 'pathname'
require 'l10n/translation_list'

module L10n
  class Localization
    attr_reader :code
    
    def initialize(code)
      @code = code
    end
    
    def data
      @data ||= TranslationParser.parse(strings.read)
    end
    
    def data=(data)
      @data = data
    end
    
    def write
      strings.parent.mkpath
      strings.open('w') {|f| f << data }
    end
    
    def strings
      path+'Localizable.strings'
    end
    
    def xstrings
      path+'Localizable.xstrings'
    end
    
    def path
      @path ||= Pathname(File.expand_path("../../../data/#{code}.lproj", __FILE__))
    end
    
    def self.[](code)
      new(code)
    end
    
    def self.all
      Pathname.glob(File.expand_path("../../../data/*.lproj", __FILE__)).map do |path|
        new(path.basename('.lproj').to_s)
      end
    end
  end
end