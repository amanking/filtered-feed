module FilteredFeed
  class ExcludeFilter
    include GenericFilter
    process_feed_entries :exclude_if_any_expression_present

    def initialize(source, *expressions)
      @source, @expressions = source, expressions
    end

    def exclude_if_any_expression_present(entry)
      source = entry.send(@source)
      any_expression_present = @expressions.any? {|expression| expression.present_in?(source) }
      any_expression_present ? nil : entry
    end
  end
end