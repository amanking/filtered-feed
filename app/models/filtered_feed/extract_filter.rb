module FilteredFeed
  class ExtractFilter
    include GenericFilter
    process_feed_entries :extract_expressions

    def initialize(source, *expressions)
      @source, @expressions = source, expressions
    end

    def extract_expressions(entry)
      source = entry.send(@source)
      @expressions.collect_concat do |expression|
        expression.extract_from(source).collect do |extract|
          entry.clone_with_overrides(@source => extract)
        end
      end
    end
  end
end