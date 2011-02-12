require 'l10n/translation'
require 'l10n/translation_list'

%%{
  machine hello;

  action start_comment { comment_start = p }
  action end_comment { comment = string_in_range[comment_start...p] }

  action start_original { original_start = p }
  action end_original { original = string_in_range[original_start...p] }

  action start_translated { translated_start = p }
  action end_translated { translated = string_in_range[translated_start...p] }

  action record_translation { translations << Translation.new(original, translated, comment) }

  newline = '\n' @{ line += 1 };
  whitespace = [ \t];

  comment = '/*' (any | newline)* '*/';
  quotedString = '"' ('\\"' | [^"])* '"';
  translation = comment >start_comment %end_comment newline
                quotedString >start_original %end_original whitespace* '=' whitespace*
                quotedString >start_translated %end_translated ';' whitespace*;

  main := (translation %record_translation newline+)* newline*;
}%%

module L10n
  UTF8_BOM = [0xEF, 0xBB, 0xBF].freeze
  UTF16LE_BOM = [0xFF, 0xFE].freeze
  UTF16BE_BOM = [0xFE, 0xFF].freeze

  class TranslationParser
    def self.parse(data)
      data = data.unpack("C*") if data.is_a?(String)

      has_bom = data[0, UTF8_BOM.size] == UTF8_BOM
      UTF8_BOM.size.times { data.shift } if has_bom
      if [UTF16BE_BOM, UTF16LE_BOM].include?(data[0, 2])
        raise ArgumentError, "this script does not yet support UTF-16"
      end

      translations = TranslationList.new
      translations.bom = UTF8_BOM if has_bom
      eof = false
      line = 1

      string_in_range = proc {|range| data[range].pack('C*') }

      %% write init;
      %% write exec;

      if cs == 0
        raise SyntaxError, "unexpected character on line #{line}: #{data[p,1].pack('C*')} (#{data[p]})"
      end

      return translations
    end

    %% write data;
  end
end