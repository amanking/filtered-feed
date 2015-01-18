module FilteredFeed
  class Reader
    def initialize
      @filters = []
    end

    def filter(filter)
      @filters << filter
      self
    end

    def fetch(feed_url)
      feedzirra_feed = Feedjira::Feed.fetch_and_parse(feed_url)
      filtered_feed(feedzirra_feed)
    end

    def parse(feed_document)
      feedzirra_feed = Feedjira::Feed.parse(feed_document)
      filtered_feed(feedzirra_feed)
    end

    private
    def filtered_feed(feedzirra_feed)
      feed = feed_from(feedzirra_feed)
      @filters.inject(feed) {|result, filter| filter.process(result) }
    end

    def feed_from(feedzirra_feed)
      Feed.new(
        :url => feedzirra_feed.url,
        :feed_url => feedzirra_feed.feed_url,
        :title => feedzirra_feed.title,
        :description => feedzirra_feed.description,
        :last_modified => feedzirra_feed.last_modified,
        :entries => feedzirra_feed.entries.collect {|feedzirra_entry| entry_from(feedzirra_entry) }
      )
    end

    def entry_from(feedzirra_entry)
      Entry.new(
        :author => stripped_text(feedzirra_entry.author),
        :updated => feedzirra_entry.updated,
        :published => feedzirra_entry.published,
        :id => feedzirra_entry.id,
        :url => (stripped_text(feedzirra_entry.url) || "").gsub('#38;', ''),
        :title => stripped_text(feedzirra_entry.title),
        :categories => feedzirra_entry.categories,
        :content => stripped_text(feedzirra_entry.content),
        :summary => stripped_text(feedzirra_entry.summary)
      )
    end

    def stripped_text(text)
      text.try(:strip)
    end
  end
end