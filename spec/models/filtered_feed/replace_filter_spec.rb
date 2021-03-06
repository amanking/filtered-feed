require 'spec_helper'

module FilteredFeed
  describe ReplaceFilter do
    before :each do
      @feed = Feed.new(
        :url => 'some/url', :feed_url => 'some/feed/url', :title => 'some title', :description => 'some description', :last_modified => some_time,
          :entries => [
            Entry.new(
              :author => 'x', :updated => some_time, :published => some_time, :id => 'some-id1', :url => 'some-id1', :title => 'some title', :categories => [],
                :content => %{Here are some images: <br /> <img src="http://s10.postimage.org/op3c1v1ax/218.png" alt='Image' /> <br /> <img src="http://s10.postimage.org/op3c1v1ax/219.png" alt="Image" /> <br /> And here are some youtube videos: <br /> <a class="postlink" href="http://www.youtube.com/watch?v=1GriGJmW7fM">http://www.youtube.com/watch?v=1GriGJmW7fM</a><br /> <a class="postlink" href="http://www.youtube.com/watch?v=E4s7OI7IbvY">http://www.youtube.com/watch?v=E4s7OI7IbvY</a><br />},
                  :summary => nil
            ),
            Entry.new(
              :author => 'x', :updated => some_time, :published => some_time, :id => 'some-id2', :url => 'some-id2', :title => 'some title', :categories => [],
                :content => %{No images here}, :summary => nil
            ),
            Entry.new(
              :author => 'x', :updated => some_time, :published => some_time, :id => 'some-id3', :url => 'some-id3', :title => 'some title', :categories => [],
                :content => %{No images here again}, :summary => nil
            ),
            Entry.new(
              :author => 'x', :updated => some_time, :published => some_time, :id => 'some-id4', :url => 'some-id4', :title => 'some title', :categories => [],
                :content => %{ here is an image: <br /> <img src="http://s15.postimage.org/z7k4g46nf/ring.jpg" alt="Image" /> <br />},
                  :summary => nil
            )
          ]
      )
    end

    context "single filter expression" do
      it "should replace only given img xpath matches in target field" do
        filter = ReplaceFilter.new("content", XpathExpression.new(%{//img[@alt="Image"]}))
        output = filter.process(@feed)
        output.entries.collect(&:to_hash).should == [
          {:author => 'x', :updated => some_time, :published => some_time, :id => 'some-id1', :url => 'some-id1', :title => 'some title', :categories => [],
            :content => %{Here are some images: <br /> <span style=\"text-decoration:line-through\">&nbsp;&nbsp;image&nbsp;&nbsp;</span> <br /> <span style=\"text-decoration:line-through\">&nbsp;&nbsp;image&nbsp;&nbsp;</span> <br /> And here are some youtube videos: <br /> <a class="postlink" href="http://www.youtube.com/watch?v=1GriGJmW7fM">http://www.youtube.com/watch?v=1GriGJmW7fM</a><br /> <a class="postlink" href="http://www.youtube.com/watch?v=E4s7OI7IbvY">http://www.youtube.com/watch?v=E4s7OI7IbvY</a><br />}, :summary => nil},
          {:author => 'x', :updated => some_time, :published => some_time, :id => 'some-id2', :url => 'some-id2', :title => 'some title', :categories => [],
            :content => %{No images here}, :summary => nil
          },
          {:author => 'x', :updated => some_time, :published => some_time, :id => 'some-id3', :url => 'some-id3', :title => 'some title', :categories => [],
            :content => %{No images here again}, :summary => nil},
          {:author => 'x', :updated => some_time, :published => some_time, :id => 'some-id4', :url => 'some-id4', :title => 'some title', :categories => [],
            :content => %{ here is an image: <br /> <span style=\"text-decoration:line-through\">&nbsp;&nbsp;image&nbsp;&nbsp;</span> <br />}, :summary => nil}
        ]
      end

      it "should replace only given anchor xpath matches in target field" do
        filter = ReplaceFilter.new("content", XpathExpression.new(%{//a[contains(@href, "youtube.com")]}))
        output = filter.process(@feed)
        output.entries.collect(&:to_hash).should == [
          {:author => 'x', :updated => some_time, :published => some_time, :id => 'some-id1', :url => 'some-id1', :title => 'some title', :categories => [],
            :content => %{Here are some images: <br /> <img src="http://s10.postimage.org/op3c1v1ax/218.png" alt="Image" /> <br /> <img src="http://s10.postimage.org/op3c1v1ax/219.png" alt="Image" /> <br /> And here are some youtube videos: <br /> <span style=\"text-decoration:line-through\">&nbsp;&nbsp;link&nbsp;&nbsp;</span> <br /> <span style=\"text-decoration:line-through\">&nbsp;&nbsp;link&nbsp;&nbsp;</span> <br />},
              :summary => nil},
          {:author => 'x', :updated => some_time, :published => some_time, :id => 'some-id2', :url => 'some-id2', :title => 'some title', :categories => [],
            :content => %{No images here}, :summary => nil
          },
          {:author => 'x', :updated => some_time, :published => some_time, :id => 'some-id3', :url => 'some-id3', :title => 'some title', :categories => [],
            :content => %{No images here again}, :summary => nil},
          {:author => 'x', :updated => some_time, :published => some_time, :id => 'some-id4', :url => 'some-id4', :title => 'some title', :categories => [],
            :content => %{ here is an image: <br /> <img src="http://s15.postimage.org/z7k4g46nf/ring.jpg" alt="Image" /> <br />}, :summary => nil}
        ]
      end

      it "should replace only given regexp matches in target field" do
        filter = ReplaceFilter.new("content", RegexpExpression.new(%{im.?ges}))
        output = filter.process(@feed)
        output.entries.collect(&:to_hash).should == [
          {:author => 'x', :updated => some_time, :published => some_time, :id => 'some-id1', :url => 'some-id1', :title => 'some title', :categories => [],
            :content => %{Here are some ******: <br /> <img src="http://s10.postimage.org/op3c1v1ax/218.png" alt='Image' /> <br /> <img src="http://s10.postimage.org/op3c1v1ax/219.png" alt="Image" /> <br /> And here are some youtube videos: <br /> <a class="postlink" href="http://www.youtube.com/watch?v=1GriGJmW7fM">http://www.youtube.com/watch?v=1GriGJmW7fM</a><br /> <a class="postlink" href="http://www.youtube.com/watch?v=E4s7OI7IbvY">http://www.youtube.com/watch?v=E4s7OI7IbvY</a><br />},
              :summary => nil},
          {:author => 'x', :updated => some_time, :published => some_time, :id => 'some-id2', :url => 'some-id2', :title => 'some title', :categories => [],
            :content => %{No ****** here}, :summary => nil},
          {:author => 'x', :updated => some_time, :published => some_time, :id => 'some-id3', :url => 'some-id3', :title => 'some title', :categories => [],
            :content => %{No ****** here again}, :summary => nil},
          {:author => 'x', :updated => some_time, :published => some_time, :id => 'some-id4', :url => 'some-id4', :title => 'some title', :categories => [],
            :content => %{ here is an image: <br /> <img src="http://s15.postimage.org/z7k4g46nf/ring.jpg" alt="Image" /> <br />},
              :summary => nil}
        ]
      end
    end

    context "composite filter expression" do
      it "should replace given img and anchor xpath matches in target field" do
        filter = ReplaceFilter.new("content", XpathExpression.new(%{//img[@alt="Image"]}), XpathExpression.new(%{//a[contains(@href, "youtube.com")]}))
        output = filter.process(@feed)
        output.entries.collect(&:to_hash).should == [
          {:author => 'x', :updated => some_time, :published => some_time, :id => 'some-id1', :url => 'some-id1', :title => 'some title', :categories => [],
            :content => %{Here are some images: <br /> <span style=\"text-decoration:line-through\">  image  </span> <br /> <span style=\"text-decoration:line-through\">  image  </span> <br /> And here are some youtube videos: <br /> <span style=\"text-decoration:line-through\">&nbsp;&nbsp;link&nbsp;&nbsp;</span> <br /> <span style=\"text-decoration:line-through\">&nbsp;&nbsp;link&nbsp;&nbsp;</span> <br />},
              :summary => nil},
          {:author => 'x', :updated => some_time, :published => some_time, :id => 'some-id2', :url => 'some-id2', :title => 'some title', :categories => [],
            :content => %{No images here}, :summary => nil
          },
          {:author => 'x', :updated => some_time, :published => some_time, :id => 'some-id3', :url => 'some-id3', :title => 'some title', :categories => [],
            :content => %{No images here again}, :summary => nil},
          {:author => 'x', :updated => some_time, :published => some_time, :id => 'some-id4', :url => 'some-id4', :title => 'some title', :categories => [],
            :content => %{ here is an image: <br /> <span style=\"text-decoration:line-through\">  image  </span> <br />}, :summary => nil}
        ]
      end
    end

    def some_time
      @some_time ||= Time.now
    end
  end
end