# line 1 "lib/l10n/translation_parser.rl"
require 'l10n/translation'
require 'l10n/translation_list'

# line 28 "lib/l10n/translation_parser.rl"


module L10n
  class TranslationParser
    def self.parse(data)
      data = data.unpack("c*") if data.is_a?(String)
    
      translations = TranslationList.new
      eof = false
    
      string_in_range = proc {|range| data[range].pack('c*') }

      
# line 20 "lib/l10n/translation_parser.rb"
begin
	p ||= 0
	pe ||= data.length
	cs = hello_start
end
# line 41 "lib/l10n/translation_parser.rl"
      
# line 28 "lib/l10n/translation_parser.rb"
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
# line 144 "lib/l10n/translation_parser.rb"
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
# line 42 "lib/l10n/translation_parser.rl"
    
      return translations
    end
  
    
# line 176 "lib/l10n/translation_parser.rb"
class << self
	attr_accessor :_hello_actions
	private :_hello_actions, :_hello_actions=
end
self._hello_actions = [
	0, 1, 0, 1, 1, 1, 2, 1, 
	3, 1, 4, 1, 5, 1, 6
]

class << self
	attr_accessor :_hello_key_offsets
	private :_hello_key_offsets, :_hello_key_offsets=
end
self._hello_key_offsets = [
	0, 0, 1, 2, 4, 6, 8, 11, 
	15, 19, 23, 26, 28, 30, 34, 38, 
	41, 45, 49, 53, 56, 62, 68, 73, 
	79, 85, 90, 94, 98, 101, 104, 108, 
	110, 111, 114, 119
]

class << self
	attr_accessor :_hello_trans_keys
	private :_hello_trans_keys, :_hello_trans_keys=
end
self._hello_trans_keys = [
	42, 42, 42, 47, 10, 42, 34, 42, 
	34, 42, 92, 9, 32, 42, 61, 9, 
	32, 42, 61, 9, 32, 34, 42, 34, 
	42, 92, 42, 59, 10, 42, 34, 42, 
	47, 92, 10, 34, 42, 92, 34, 42, 
	92, 34, 42, 59, 92, 34, 42, 47, 
	92, 10, 34, 42, 92, 34, 42, 92, 
	9, 32, 34, 42, 61, 92, 9, 32, 
	34, 42, 61, 92, 9, 32, 34, 42, 
	92, 9, 32, 34, 42, 61, 92, 9, 
	32, 34, 42, 61, 92, 9, 32, 34, 
	42, 92, 34, 42, 59, 92, 10, 34, 
	42, 92, 34, 42, 92, 34, 42, 92, 
	10, 34, 42, 92, 10, 47, 10, 10, 
	42, 47, 10, 34, 42, 47, 92, 10, 
	34, 42, 47, 92, 0
]

class << self
	attr_accessor :_hello_single_lengths
	private :_hello_single_lengths, :_hello_single_lengths=
end
self._hello_single_lengths = [
	0, 1, 1, 2, 2, 2, 3, 4, 
	4, 4, 3, 2, 2, 4, 4, 3, 
	4, 4, 4, 3, 6, 6, 5, 6, 
	6, 5, 4, 4, 3, 3, 4, 2, 
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
	0, 0, 2, 4, 7, 10, 13, 17, 
	22, 27, 32, 36, 39, 42, 47, 52, 
	56, 61, 66, 71, 75, 82, 89, 95, 
	102, 109, 115, 120, 125, 129, 133, 138, 
	141, 143, 147, 153
]

class << self
	attr_accessor :_hello_indicies
	private :_hello_indicies, :_hello_indicies=
end
self._hello_indicies = [
	0, 1, 2, 0, 2, 3, 0, 4, 
	2, 0, 5, 2, 0, 7, 8, 9, 
	6, 10, 10, 2, 11, 0, 12, 12, 
	2, 13, 0, 13, 13, 14, 2, 0, 
	16, 17, 18, 15, 2, 19, 0, 20, 
	2, 0, 16, 17, 21, 18, 15, 22, 
	16, 17, 18, 15, 23, 17, 18, 15, 
	7, 8, 24, 9, 6, 7, 8, 25, 
	9, 6, 26, 7, 8, 9, 6, 27, 
	8, 9, 6, 28, 28, 7, 8, 29, 
	9, 6, 30, 30, 7, 8, 31, 9, 
	6, 31, 31, 32, 8, 9, 6, 33, 
	33, 16, 17, 34, 18, 15, 35, 35, 
	16, 17, 36, 18, 15, 36, 36, 37, 
	17, 18, 15, 16, 17, 38, 18, 15, 
	39, 16, 17, 18, 15, 40, 17, 18, 
	15, 41, 8, 9, 6, 42, 7, 8, 
	9, 6, 43, 44, 1, 43, 1, 45, 
	2, 46, 0, 47, 16, 17, 48, 18, 
	15, 49, 7, 8, 50, 9, 6, 0
]

class << self
	attr_accessor :_hello_trans_targs
	private :_hello_trans_targs, :_hello_trans_targs=
end
self._hello_trans_targs = [
	2, 0, 3, 4, 5, 6, 6, 7, 
	17, 29, 8, 9, 8, 9, 10, 10, 
	11, 13, 28, 12, 33, 14, 15, 16, 
	30, 18, 19, 20, 21, 22, 21, 22, 
	23, 24, 25, 24, 25, 26, 27, 34, 
	26, 20, 35, 32, 1, 33, 2, 34, 
	10, 35, 6
]

class << self
	attr_accessor :_hello_trans_actions
	private :_hello_trans_actions, :_hello_trans_actions=
end
self._hello_trans_actions = [
	0, 0, 0, 0, 3, 5, 0, 0, 
	0, 0, 7, 7, 0, 0, 9, 0, 
	0, 0, 0, 11, 13, 0, 3, 5, 
	11, 0, 3, 5, 7, 7, 0, 0, 
	9, 7, 7, 0, 0, 9, 11, 13, 
	0, 0, 13, 0, 1, 0, 1, 0, 
	1, 0, 1
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

# line 47 "lib/l10n/translation_parser.rl"
  end
end