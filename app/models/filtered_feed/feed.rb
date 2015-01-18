module FilteredFeed
  class Feed
    include AttributeDriven
    attributes :url, :feed_url, :title, :description, :last_modified, :entries

    include Mixins::AttributeDrivenCloneable
    include Mixins::CustomSerialization::ToHash
  end
end