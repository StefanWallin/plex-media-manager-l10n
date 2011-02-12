module L10n
  class Translation
    attr_accessor :original, :translated, :comment

    include Comparable

    def initialize(original, translated, comment=nil)
      self.original   = original
      self.translated = translated
      self.comment    = comment
    end

    def original=(original)
      @original = process_quoted_string(original)
    end

    def translated=(translated)
      @translated = process_quoted_string(translated)
    end

    def comment=(comment)
      if comment && comment[0,2] == '/*' && comment[-2,2] == '*/'
        comment = comment[2..-4].strip
      end

      @comment = comment
    end

    def to_str
      result = ''

      result += "/* #{comment} */\n" if comment
      result += "#{quote(original)} = #{quote(translated)};"

      return result
    end

    def to_s
      to_str
    end

    def <=>(other)
      self.original.casecmp(other.original)
    end

    private

    def process_quoted_string(string)
      if string[0,1] == '"' && string[-1,1] == '"'
        return string[1..-2].gsub('\\"', '"')
      end

      return string
    end

    def quote(string)
      %{"#{string.gsub('"', '\\"')}"}
    end
  end
end