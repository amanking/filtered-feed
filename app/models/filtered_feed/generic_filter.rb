module FilteredFeed
  module GenericFilter

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def process_feed_entries(method_name)
        include InstanceMethods

        define_method(:process_entry) do |entry|
          send(method_name, entry)
        end
      end
    end

    module InstanceMethods
      def process(feed)
        feed.clone_with_overrides(:entries => process_entries(feed))
      end

      def process_entries(feed)
        feed.entries.collect_concat {|entry| process_entry(entry) }.compact
      end
    end
  end
end