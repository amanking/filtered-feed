module FilteredFeed
  class ReplaceFilter
    include GenericFilter
    process_feed_entries :replace_expressions

    def initialize(source, *expressions)
      @source, @expressions = source, expressions
    end

    def replace_expressions(entry)
      result = @expressions.inject(entry.send(@source)) do |result, expression|
        expression.replace_in(result)
      end
      entry.clone_with_overrides(@source => result)
    end
  end
end