module FilteredFeed
  class ExpressionFactory
    include Singleton

    def create(params)
      as_specifications(params).collect do |specification|
        expression_from(specification)
      end
    end

  private
    def as_specifications(params)
      [params].flatten
    end

    def expression_from(specification)
      case specification
      when Hash
        type, value = specification.keys.first, specification.values.first
        expression_class(type).new(value)
      when String
        RegexpExpression.new(Regexp.escape(specification))
      end
    end

    def expression_class(type)
      "FilteredFeed::#{type.to_s.camelize}Expression".constantize
    end
  end
end