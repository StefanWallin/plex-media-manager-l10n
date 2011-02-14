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
	4, 1, 5, 1, 6, 1, 7, 2, 
	1, 7, 2, 6, 7, 2, 7, 1, 
	2, 7, 6
]

class << self
	attr_accessor :_hello_key_offsets
	private :_hello_key_offsets, :_hello_key_offsets=
end
self._hello_key_offsets = [
	0, 0, 1, 3, 4, 5, 6, 8, 
	11, 14, 17, 19, 20, 23, 25, 28, 
	33, 36, 40, 43, 47, 49, 52, 54, 
	57, 61, 66, 71, 76, 79, 82, 84, 
	89, 94, 98, 103, 108, 112, 114, 118, 
	125, 132, 138, 145, 152, 155, 158, 160, 
	163, 168, 171, 175, 180, 186, 190, 195, 
	199, 203, 208, 214, 218, 223, 227, 231, 
	237, 241, 244, 248, 254, 259, 265, 272
]

class << self
	attr_accessor :_hello_trans_keys
	private :_hello_trans_keys, :_hello_trans_keys=
end
self._hello_trans_keys = [
	42, 10, 42, 47, 10, 34, 34, 92, 
	9, 32, 61, 9, 32, 61, 9, 32, 
	34, 34, 92, 59, 9, 10, 32, 34, 
	92, 34, 59, 92, 9, 10, 32, 34, 
	92, 34, 42, 92, 10, 34, 42, 92, 
	10, 42, 59, 9, 10, 32, 42, 10, 
	42, 10, 42, 47, 10, 42, 10, 34, 
	42, 10, 34, 42, 92, 9, 10, 32, 
	42, 61, 9, 10, 32, 42, 61, 9, 
	10, 32, 34, 42, 34, 47, 92, 10, 
	34, 92, 34, 92, 9, 32, 34, 61, 
	92, 9, 32, 34, 61, 92, 9, 32, 
	34, 92, 9, 32, 34, 61, 92, 9, 
	32, 34, 61, 92, 9, 32, 34, 92, 
	34, 92, 10, 34, 42, 92, 9, 10, 
	32, 34, 42, 61, 92, 9, 10, 32, 
	34, 42, 61, 92, 9, 10, 32, 34, 
	42, 92, 9, 10, 32, 34, 42, 61, 
	92, 9, 10, 32, 34, 42, 61, 92, 
	34, 47, 92, 10, 34, 92, 34, 92, 
	34, 59, 92, 9, 10, 32, 34, 92, 
	34, 42, 92, 10, 34, 42, 92, 10, 
	34, 42, 59, 92, 9, 10, 32, 34, 
	42, 92, 10, 34, 42, 92, 10, 34, 
	42, 47, 92, 10, 34, 42, 92, 10, 
	34, 42, 92, 10, 34, 42, 59, 92, 
	9, 10, 32, 34, 42, 92, 10, 34, 
	42, 92, 10, 34, 42, 47, 92, 10, 
	34, 42, 92, 10, 34, 42, 92, 9, 
	10, 32, 34, 42, 92, 9, 10, 32, 
	47, 9, 10, 32, 9, 10, 32, 47, 
	9, 10, 32, 34, 47, 92, 9, 10, 
	32, 42, 47, 9, 10, 32, 34, 47, 
	92, 9, 10, 32, 34, 42, 47, 92, 
	9, 10, 32, 34, 42, 47, 92, 0
]

class << self
	attr_accessor :_hello_single_lengths
	private :_hello_single_lengths, :_hello_single_lengths=
end
self._hello_single_lengths = [
	0, 1, 2, 1, 1, 1, 2, 3, 
	3, 3, 2, 1, 3, 2, 3, 5, 
	3, 4, 3, 4, 2, 3, 2, 3, 
	4, 5, 5, 5, 3, 3, 2, 5, 
	5, 4, 5, 5, 4, 2, 4, 7, 
	7, 6, 7, 7, 3, 3, 2, 3, 
	5, 3, 4, 5, 6, 4, 5, 4, 
	4, 5, 6, 4, 5, 4, 4, 6, 
	4, 3, 4, 6, 5, 6, 7, 7
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
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0
]

class << self
	attr_accessor :_hello_index_offsets
	private :_hello_index_offsets, :_hello_index_offsets=
end
self._hello_index_offsets = [
	0, 0, 2, 5, 7, 9, 11, 14, 
	18, 22, 26, 29, 31, 35, 38, 42, 
	48, 52, 57, 61, 66, 69, 73, 76, 
	80, 85, 91, 97, 103, 107, 111, 114, 
	120, 126, 131, 137, 143, 148, 151, 156, 
	164, 172, 179, 187, 195, 199, 203, 206, 
	210, 216, 220, 225, 231, 238, 243, 249, 
	254, 259, 265, 272, 277, 283, 288, 293, 
	300, 305, 309, 314, 321, 327, 334, 342
]

class << self
	attr_accessor :_hello_indicies
	private :_hello_indicies, :_hello_indicies=
end
self._hello_indicies = [
	0, 1, 2, 3, 0, 4, 0, 5, 
	1, 6, 1, 8, 9, 7, 10, 10, 
	11, 1, 12, 12, 13, 1, 13, 13, 
	14, 1, 16, 17, 15, 18, 1, 19, 
	20, 19, 1, 21, 17, 15, 16, 22, 
	17, 15, 23, 24, 23, 16, 17, 15, 
	16, 25, 17, 15, 26, 27, 28, 29, 
	25, 2, 3, 30, 0, 31, 32, 31, 
	3, 0, 2, 33, 0, 2, 33, 34, 
	0, 35, 3, 0, 2, 36, 3, 0, 
	38, 39, 40, 41, 37, 42, 2, 42, 
	3, 43, 0, 44, 2, 44, 3, 45, 
	0, 45, 2, 45, 46, 3, 0, 39, 
	47, 41, 37, 48, 8, 9, 7, 49, 
	9, 7, 50, 50, 8, 51, 9, 7, 
	52, 52, 8, 53, 9, 7, 53, 53, 
	54, 9, 7, 55, 55, 16, 56, 17, 
	15, 57, 57, 16, 58, 17, 15, 58, 
	58, 59, 17, 15, 60, 9, 7, 38, 
	61, 40, 41, 37, 62, 38, 62, 39, 
	40, 63, 41, 37, 64, 38, 64, 39, 
	40, 65, 41, 37, 65, 38, 65, 66, 
	40, 41, 37, 67, 26, 67, 27, 28, 
	68, 29, 25, 69, 26, 69, 27, 28, 
	70, 29, 25, 27, 71, 29, 25, 72, 
	16, 17, 15, 73, 17, 15, 8, 74, 
	9, 7, 75, 76, 75, 8, 9, 7, 
	8, 37, 9, 7, 26, 77, 28, 29, 
	25, 26, 27, 28, 78, 29, 25, 79, 
	80, 79, 27, 28, 29, 25, 26, 27, 
	81, 29, 25, 26, 27, 81, 82, 29, 
	25, 83, 27, 28, 29, 25, 26, 84, 
	28, 29, 25, 38, 39, 40, 85, 41, 
	37, 86, 87, 86, 39, 40, 41, 37, 
	38, 39, 88, 41, 37, 38, 39, 88, 
	89, 41, 37, 90, 39, 40, 41, 37, 
	38, 91, 40, 41, 37, 70, 26, 70, 
	92, 28, 29, 25, 93, 94, 93, 95, 
	1, 93, 94, 93, 1, 96, 97, 96, 
	95, 1, 98, 99, 98, 16, 100, 17, 
	15, 101, 102, 101, 3, 103, 0, 104, 
	105, 104, 8, 106, 9, 7, 107, 108, 
	107, 27, 28, 109, 29, 25, 110, 111, 
	110, 39, 40, 112, 41, 37, 0
]

class << self
	attr_accessor :_hello_trans_targs
	private :_hello_trans_targs, :_hello_trans_targs=
end
self._hello_trans_targs = [
	2, 0, 2, 3, 4, 5, 6, 6, 
	7, 37, 8, 9, 8, 9, 10, 10, 
	11, 13, 12, 12, 66, 14, 15, 15, 
	67, 17, 17, 18, 44, 50, 19, 19, 
	68, 21, 22, 23, 24, 24, 24, 25, 
	28, 38, 26, 27, 26, 27, 17, 29, 
	30, 31, 32, 33, 32, 33, 34, 35, 
	36, 35, 36, 14, 31, 39, 40, 41, 
	40, 41, 42, 43, 63, 43, 63, 45, 
	46, 47, 48, 48, 69, 51, 52, 52, 
	70, 54, 55, 56, 57, 58, 58, 71, 
	60, 61, 62, 39, 51, 65, 65, 1, 
	66, 66, 67, 67, 16, 68, 68, 20, 
	69, 69, 49, 70, 70, 53, 71, 71, 
	59
]

class << self
	attr_accessor :_hello_trans_actions
	private :_hello_trans_actions, :_hello_trans_actions=
end
self._hello_trans_actions = [
	0, 0, 13, 0, 0, 15, 3, 0, 
	0, 0, 5, 5, 0, 0, 7, 0, 
	0, 0, 9, 11, 18, 0, 9, 11, 
	18, 0, 13, 0, 0, 0, 9, 11, 
	24, 0, 0, 21, 3, 0, 13, 0, 
	0, 0, 5, 5, 0, 0, 7, 0, 
	15, 3, 5, 5, 0, 0, 7, 5, 
	5, 0, 0, 7, 0, 0, 5, 5, 
	0, 0, 7, 5, 5, 0, 0, 0, 
	15, 3, 9, 11, 18, 0, 9, 11, 
	24, 0, 0, 21, 3, 9, 11, 24, 
	0, 0, 21, 3, 7, 0, 13, 1, 
	0, 13, 0, 13, 1, 0, 13, 1, 
	0, 13, 1, 0, 13, 1, 0, 13, 
	1
]

class << self
	attr_accessor :hello_start
end
self.hello_start = 64;
class << self
	attr_accessor :hello_first_final
end
self.hello_first_final = 64;
class << self
	attr_accessor :hello_error
end
self.hello_error = 0;

class << self
	attr_accessor :hello_en_main
end
self.hello_en_main = 64;

# line 63 "lib/l10n/translation_parser.rl"
  end
end