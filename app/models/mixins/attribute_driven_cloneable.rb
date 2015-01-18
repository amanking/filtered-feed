module Mixins
  module AttributeDrivenCloneable
    def self.included(base)
      unless base.instance_methods.include?(:attributes)
        base.class_eval do
          alias_method :attributes, :attributes_from_instance_variables
        end
      end
    end

    def clone_with_overrides(overridden_attributes)
      self.class.new(attributes.merge(overridden_attributes.symbolize_keys))
    end

    def attributes_from_instance_variables
      instance_variables.inject({}) do |result, instance_variable|
        result[instance_variable.to_s.gsub(/^@/, '').to_sym] = instance_variable_get(instance_variable)
        result
      end
    end

  end
end