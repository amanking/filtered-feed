module Mixins
  module CustomSerialization
    module ToHash

      def to_hash(*attribute_names)
        return attributes if attribute_names.empty?

        attribute_names.inject({}) do |result, attribute_name|
          result[attribute_name] = self.send(attribute_name)
          result
        end
      end

    end
  end
end
