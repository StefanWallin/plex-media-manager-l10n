module L10n
  class TranslationList
    include Enumerable

    attr_accessor :bom

    def initialize(translations=nil)
      @translations = Array(translations)
    end

    def [](index)
      @translations[index]
    end

    def <<(translation)
      @translations << translation
    end

    alias_method :push, :<<

    def first
      @translations.first
    end

    def last
      @translations.last
    end

    def each(&block)
      @translations.each(&block)
    end

    def has_key?(string)
      not translation_for_string(string).nil?
    end

    def delete(translation)
      @translations.delete(translation)
    end

    def sort!
      @translations.sort!
      return self
    end

    def sort
      dup.sort!
    end

    def size
      @translations.size
    end

    def dup
      self.class.new(@translations.map {|t| t.dup })
    end

    alias_method :include?, :has_key?

    def translation_for_string(string)
      find {|translation| translation.original == string }
    end

    def translate
      raise ArgumentError, "You must provide a block to return translations for given strings" unless block_given?

      each do |translation|
        translation.translated = translation.original.split($/).map {|line| yield line}.join($/)
      end

      return nil
    end

    def to_str
      (bom ? bom.pack('C*') : '') + map {|translation| translation.to_str + $/ + $/ }.join
    end

    def to_s
      to_str
    end
  end
end
