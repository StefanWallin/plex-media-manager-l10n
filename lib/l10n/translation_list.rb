module L10n
  class TranslationList
    include Enumerable

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

    def translate
      raise ArgumentError, "You must provide a block to return translations for given strings" unless block_given?

      each do |translation|
        translation.translated = translation.original.split($/).map {|line| yield line}.join($/)
      end

      return nil
    end

    def to_str
      map {|translation| translation.to_str + $/ + $/ }.join
    end

    def to_s
      to_str
    end
  end
end