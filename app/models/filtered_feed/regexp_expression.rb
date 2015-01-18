module FilteredFeed
  class RegexpExpression
    include AttributeDriven
    equality_based_on :regexp

    def initialize(regexp_string)
      @regexp = RegexpWithOptions.from(regexp_string).to_regexp
    end

    def extract_from(source)
      source.scan(@regexp)
    end

    def replace_in(source)
      source.gsub(@regexp) {|match| "*" * match.length }
    end

    def present_in?(source)
      source =~ @regexp
    end

    class RegexpWithOptions
      OPTIONS = {
        'i' => Regexp::IGNORECASE,
        'x' => Regexp::EXTENDED,
        'm' => Regexp::MULTILINE
      }
      OPTIONS_PATTERN = /%([#{OPTIONS.keys}]{0,#{OPTIONS.keys.length}})%$/

      def self.from(regexp_string)
        match = regexp_string.match(OPTIONS_PATTERN)
        new(regexp_string.sub(OPTIONS_PATTERN, ''), match ? match[1] : "")
      end

      def initialize(regexp_string, options_string)
        @regexp_string, @options_string = regexp_string, options_string
      end

      def to_regexp
        Regexp.new(@regexp_string, options)
      end

    private

      def options
        @options ||= @options_string.chars.inject(0) {|result, option_char| result += OPTIONS[option_char] }
      end
    end

  end
end