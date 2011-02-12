# line 1 "lib/l10n/translation_parser.rl"
require 'l10n/translation'
require 'l10n/translation_list'

# line 28 "lib/l10n/translation_parser.rl"


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

      
# line 32 "lib/l10n/translation_parser.rb"
begin
	p ||= 0
	pe ||= data.length
	cs = hello_start
end
# line 53 "lib/l10n/translation_parser.rl"
      
# line 40 "lib/l10n/translation_parser.rb"
begin
	_klen, _trans, _keys, _acts, _nacts = nil
	_goto_level = 0
	_resume = 10
	_eof_trans = 15
	_again = 20
	_test_eof = 30
	_out = 40
	while true
	_trigger_goto = false
	if _goto_level <= 0
	if p == pe
		_goto_level = _test_eof
		next
	end
	if cs == 0
		_goto_level = _out
		next
	end
	end
	if _goto_level <= _resume
	_keys = _hello_key_offsets[cs]
	_trans = _hello_index_offsets[cs]
	_klen = _hello_single_lengths[cs]
	_break_match = false
	
	begin
	  if _klen > 0
	     _lower = _keys
	     _upper = _keys + _klen - 1

	     loop do
	        break if _upper < _lower
	        _mid = _lower + ( (_upper - _lower) >> 1 )

	        if data[p] < _hello_trans_keys[_mid]
	           _upper = _mid - 1
	        elsif data[p] > _hello_trans_keys[_mid]
	           _lower = _mid + 1
	        else
	           _trans += (_mid - _keys)
	           _break_match = true
	           break
	        end
	     end # loop
	     break if _break_match
	     _keys += _klen
	     _trans += _klen
	  end
	  _klen = _hello_range_lengths[cs]
	  if _klen > 0
	     _lower = _keys
	     _upper = _keys + (_klen << 1) - 2
	     loop do
	        break if _upper < _lower
	        _mid = _lower + (((_upper-_lower) >> 1) & ~1)
	        if data[p] < _hello_trans_keys[_mid]
	          _upper = _mid - 2
	        elsif data[p] > _hello_trans_keys[_mid+1]
	          _lower = _mid + 2
	        else
	          _trans += ((_mid - _keys) >> 1)
	          _break_match = true
	          break
	        end
	     end # loop
	     break if _break_match
	     _trans += _klen
	  end
	end while false
	_trans = _hello_indicies[_trans]
	cs = _hello_trans_targs[_trans]
	if _hello_trans_actions[_trans] != 0
		_acts = _hello_trans_actions[_trans]
		_nacts = _hello_actions[_acts]
		_acts += 1
		while _nacts > 0
			_nacts -= 1
			_acts += 1
			case _hello_actions[_acts - 1]
when 0 then
# line 7 "lib/l10n/translation_parser.rl"
		begin
 comment_start = p 		end
# line 7 "lib/l10n/translation_parser.rl"
when 1 then
# line 8 "lib/l10n/translation_parser.rl"
		begin
 comment = string_in_range[comment_start...p] 		end
# line 8 "lib/l10n/translation_parser.rl"
when 2 then
# line 10 "lib/l10n/translation_parser.rl"
		begin
 original_start = p 		end
# line 10 "lib/l10n/translation_parser.rl"
when 3 then
# line 11 "lib/l10n/translation_parser.rl"
		begin
 original = string_in_range[original_start...p] 		end
# line 11 "lib/l10n/translation_parser.rl"
when 4 then
# line 13 "lib/l10n/translation_parser.rl"
		begin
 translated_start = p 		end
# line 13 "lib/l10n/translation_parser.rl"
when 5 then
# line 14 "lib/l10n/translation_parser.rl"
		begin
 translated = string_in_range[translated_start...p] 		end
# line 14 "lib/l10n/translation_parser.rl"
when 6 then
# line 16 "lib/l10n/translation_parser.rl"
		begin
 translations << Translation.new(original, translated, comment) 		end
# line 16 "lib/l10n/translation_parser.rl"
when 7 then
# line 18 "lib/l10n/translation_parser.rl"
		begin
 line += 1 		end
# line 18 "lib/l10n/translation_parser.rl"
# line 161 "lib/l10n/translation_parser.rb"
			end # action switch
		end
	end
	if _trigger_goto
		next
	end
	end
	if _goto_level <= _again
	if cs == 0
		_goto_level = _out
		next
	end
	p += 1
	if p != pe
		_goto_level = _resume
		next
	end
	end
	if _goto_level <= _test_eof
	end
	if _goto_level <= _out
		break
	end
	end
	end
# line 54 "lib/l10n/translation_parser.rl"

      if cs == 0
        raise SyntaxError, "unexpected character on line #{line}: #{data[p,1].pack('C*')} (#{data[p]})"
      end

      return translations
    end

    
# line 197 "lib/l10n/translation_parser.rb"
class << self
	attr_accessor :_hello_actions
	private :_hello_actions, :_hello_actions=
end
self._hello_actions = [
	0, 1, 0, 1, 2, 1, 3, 1, 
	4, 1, 5, 1, 7, 2, 7, 1, 
	2, 7, 6
]

class << self
	attr_accessor :_hello_key_offsets
	private :_hello_key_offsets, :_hello_key_offsets=
end
self._hello_key_offsets = [
	0, 0, 1, 3, 6, 8, 11, 15, 
	20, 25, 30, 34, 37, 41, 46, 50, 
	54, 59, 64, 68, 72, 79, 86, 92, 
	99, 106, 112, 117, 123, 127, 131, 137, 
	139, 140, 143, 148
]

class << self
	attr_accessor :_hello_trans_keys
	private :_hello_trans_keys, :_hello_trans_keys=
end
self._hello_trans_keys = [
	42, 10, 42, 10, 42, 47, 10, 42, 
	10, 34, 42, 10, 34, 42, 92, 9, 
	10, 32, 42, 61, 9, 10, 32, 42, 
	61, 9, 10, 32, 34, 42, 10, 34, 
	42, 92, 10, 42, 59, 9, 10, 32, 
	42, 10, 34, 42, 47, 92, 10, 34, 
	42, 92, 10, 34, 42, 92, 10, 34, 
	42, 59, 92, 10, 34, 42, 47, 92, 
	10, 34, 42, 92, 10, 34, 42, 92, 
	9, 10, 32, 34, 42, 61, 92, 9, 
	10, 32, 34, 42, 61, 92, 9, 10, 
	32, 34, 42, 92, 9, 10, 32, 34, 
	42, 61, 92, 9, 10, 32, 34, 42, 
	61, 92, 9, 10, 32, 34, 42, 92, 
	10, 34, 42, 59, 92, 9, 10, 32, 
	34, 42, 92, 10, 34, 42, 92, 10, 
	34, 42, 92, 9, 10, 32, 34, 42, 
	92, 10, 47, 10, 10, 42, 47, 10, 
	34, 42, 47, 92, 10, 34, 42, 47, 
	92, 0
]

class << self
	attr_accessor :_hello_single_lengths
	private :_hello_single_lengths, :_hello_single_lengths=
end
self._hello_single_lengths = [
	0, 1, 2, 3, 2, 3, 4, 5, 
	5, 5, 4, 3, 4, 5, 4, 4, 
	5, 5, 4, 4, 7, 7, 6, 7, 
	7, 6, 5, 6, 4, 4, 6, 2, 
	1, 3, 5, 5
]

class << self
	attr_accessor :_hello_range_lengths
	private :_hello_range_lengths, :_hello_range_lengths=
end
self._hello_range_lengths = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0
]

class << self
	attr_accessor :_hello_index_offsets
	private :_hello_index_offsets, :_hello_index_offsets=
end
self._hello_index_offsets = [
	0, 0, 2, 5, 9, 12, 16, 21, 
	27, 33, 39, 44, 48, 53, 59, 64, 
	69, 75, 81, 86, 91, 99, 107, 114, 
	122, 130, 137, 143, 150, 155, 160, 167, 
	170, 172, 176, 182
]

class << self
	attr_accessor :_hello_indicies
	private :_hello_indicies, :_hello_indicies=
end
self._hello_indicies = [
	0, 1, 2, 3, 0, 2, 3, 4, 
	0, 5, 3, 0, 2, 6, 3, 0, 
	8, 9, 10, 11, 7, 12, 2, 12, 
	3, 13, 0, 14, 2, 14, 3, 15, 
	0, 15, 2, 15, 16, 3, 0, 18, 
	19, 20, 21, 17, 2, 3, 22, 0, 
	23, 24, 23, 3, 0, 18, 19, 20, 
	25, 21, 17, 26, 19, 20, 21, 17, 
	18, 27, 20, 21, 17, 8, 9, 10, 
	28, 11, 7, 8, 9, 10, 29, 11, 
	7, 30, 9, 10, 11, 7, 8, 31, 
	10, 11, 7, 32, 8, 32, 9, 10, 
	33, 11, 7, 34, 8, 34, 9, 10, 
	35, 11, 7, 35, 8, 35, 36, 10, 
	11, 7, 37, 18, 37, 19, 20, 38, 
	21, 17, 39, 18, 39, 19, 20, 40, 
	21, 17, 40, 18, 40, 41, 20, 21, 
	17, 18, 19, 20, 42, 21, 17, 43, 
	44, 43, 19, 20, 21, 17, 18, 45, 
	20, 21, 17, 8, 46, 10, 11, 7, 
	47, 48, 47, 9, 10, 11, 7, 49, 
	50, 1, 49, 1, 51, 3, 52, 0, 
	53, 19, 20, 54, 21, 17, 55, 9, 
	10, 56, 11, 7, 0
]

class << self
	attr_accessor :_hello_trans_targs
	private :_hello_trans_targs, :_hello_trans_targs=
end
self._hello_trans_targs = [
	2, 0, 2, 3, 4, 5, 6, 6, 
	6, 7, 17, 29, 8, 9, 8, 9, 
	10, 10, 10, 11, 13, 28, 12, 12, 
	33, 14, 15, 16, 30, 18, 19, 20, 
	21, 22, 21, 22, 23, 24, 25, 24, 
	25, 26, 27, 27, 34, 26, 20, 30, 
	35, 32, 1, 33, 2, 34, 10, 35, 
	6
]

class << self
	attr_accessor :_hello_trans_actions
	private :_hello_trans_actions, :_hello_trans_actions=
end
self._hello_trans_actions = [
	0, 0, 11, 0, 0, 13, 3, 0, 
	11, 0, 0, 0, 5, 5, 0, 0, 
	7, 0, 11, 0, 0, 0, 9, 0, 
	16, 0, 13, 3, 9, 0, 13, 3, 
	5, 5, 0, 0, 7, 5, 5, 0, 
	0, 7, 9, 0, 16, 0, 0, 0, 
	16, 11, 1, 11, 1, 11, 1, 11, 
	1
]

class << self
	attr_accessor :hello_start
end
self.hello_start = 31;
class << self
	attr_accessor :hello_first_final
end
self.hello_first_final = 31;
class << self
	attr_accessor :hello_error
end
self.hello_error = 0;

class << self
	attr_accessor :hello_en_main
end
self.hello_en_main = 31;

# line 63 "lib/l10n/translation_parser.rl"
  end
end