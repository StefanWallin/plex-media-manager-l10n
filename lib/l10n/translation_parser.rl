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

  newline = '\n';
  whitespace = [ \t];

  comment = '/*' (any | newline)* '*/';
  quotedString = '"' ('\\"' | [^"])* '"';
  translation = comment >start_comment %end_comment newline
                quotedString >start_original %end_original whitespace* '=' whitespace*
                quotedString >start_translated %end_translated ';' whitespace*;

  main := (translation %record_translation newline+)* newline*;
}%%

module L10n
  class TranslationParser
    def self.parse(data)
      data = data.unpack("c*") if data.is_a?(String)

      translations = TranslationList.new
      eof = false

      string_in_range = proc {|range| data[range].pack('c*') }

      %% write init;
      %% write exec;

      return translations
    end

    %% write data;
  end
end