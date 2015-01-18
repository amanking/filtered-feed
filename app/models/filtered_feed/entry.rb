module FilteredFeed
  class Entry
    include AttributeDriven
    attributes :author, :updated, :published, :id, :url, :title, :categories, :content, :summary

    include Mixins::AttributeDrivenCloneable
    include Mixins::CustomSerialization::ToHash
  end
end