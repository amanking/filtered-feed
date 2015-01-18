# coding: utf-8
# the above "magic comment" tells Ruby to treat this source code file with utf-8 encoding

require 'spec_helper'

module FilteredFeed
  describe Reader do
    context "fetching and parsing" do
      it "should fetch feed from phantomphorum source" do
        Feedjira::Feed.should_receive(:fetch_and_parse).with("http://www.somewhere.com/feed.php")
          .and_return(Feedjira::Feed.parse(fixture_contents("phantomphorum_sample_feed.xml")))

        feed = FilteredFeed::Reader.new.fetch("http://www.somewhere.com/feed.php")
        feed.url.should == "http://phantomphorum.com/index.php"
        feed.feed_url.should == "http://phantomphorum.com/feed.php"
        feed.title.should == "The Phantom Phorum"
        feed.description.should == "phantomphorum.com"
        feed.last_modified.should be_same_time_as Time.parse("2012-02-11T21:02:15+10:00")

        feed.entries.should have(15).entries
        first_entry = feed.entries.first
        first_entry.author.should == 'pcs'
        first_entry.updated.should be_same_time_as Time.parse("2012-02-11T21:03:55+10:00")
        first_entry.published.should be_same_time_as Time.parse("2012-02-11T21:02:15+10:00")
        first_entry.id.should == "http://phantomphorum.com/viewtopic.php?t=3944&p=62630#p62630"
        first_entry.url.should == "http://phantomphorum.com/viewtopic.php?t=3944&p=62630#p62630"
        first_entry.title.should == "New Phantom Stories • Re: Spoofs on Current Phantom Stories"
        first_entry.categories.should == ["New Phantom Stories"]
        first_entry.content.should == %{<div class="quotetitle">daviedo wrote:</div><div class="quotecontent"><br />This right hand/left hand thing with the Two Rings must give the Phantom problems that Frodo Baggins never dreamed of.<br /></div><br />Very appropriate spoof, considering the ongoing debate  <img src="http://phantomphorum.com/images/smilies/icon_smile.gif" alt=":)" title="Smile" /> . Technically, the Phantom has to mark all evil doers with the  <img src="http://phantomphorum.com/images/smilies/bad_mark.gif" alt=":badmark:" title="Bad Mark" /> mark. For that, he has to use his right fist. In case, he uses his head, or a stick or his feet or anything else to hit a baddie, the  <img src="http://phantomphorum.com/images/smilies/bad_mark.gif" alt=":badmark:" title="Bad Mark" /> mark won't be there. Do you think that to fulfill the  <img src="http://phantomphorum.com/images/smilies/bad_mark.gif" alt=":badmark:" title="Bad Mark" /> mark obligation, he will hit the guy again, even if he is unconscious? <br /><br />Weighty points to ponder upon..<br /><br />pcs<p>Statistics: Posted by <a href="http://phantomphorum.com/memberlist.php?mode=viewprofile&amp;u=243">pcs</a> — Sat 11 Feb, 2012 9:02 pm</p><hr />}
        first_entry.summary.should be_nil
      end

      it "should fetch feed from chroniclechamber source" do
        Feedjira::Feed.should_receive(:fetch_and_parse).with("http://www.somewhere.com/feed.php")
          .and_return(Feedjira::Feed.parse(fixture_contents("chroniclechamber_sample_feed.xml")))

        feed = FilteredFeed::Reader.new.fetch("http://www.somewhere.com/feed.php")
        feed.url.should == "http://www.chroniclechamber.com"
        # feed.feed_url.should == "http://feeds.feedburner.com/Chroniclechamber"
        feed.title.should == "ChronicleChamber"
        feed.description.should == "The digital Skull Cave!"
        feed.last_modified.should be_same_time_as Time.parse("Tue, 28 Feb 2012 10:57:53 +0000")

        feed.entries.should have(10).entries
        first_entry = feed.entries.first
        first_entry.author.should == 'JoeMD'
        first_entry.updated.should be_nil
        first_entry.published.should be_same_time_as Time.parse("Tue, 28 Feb 2012 10:57:53 +0000")
        first_entry.id.should == "http://www.chroniclechamber.com/?p=1110"
        first_entry.url.should == "http://www.chroniclechamber.com/2012/02/newspaper-strips-finally-active/"
        first_entry.title.should == "Newspaper Strips Finally Active!"
        first_entry.categories.should == ["Comics", "News", "Site", "Strips", "KFS", "newspaper strips", "site"]
        first_entry.content.should be_nil
        first_entry.summary.should == %{Since our relaunch, one page had lagged behind the others &#8211; Newspaper Strips. But no more! Beginning with the current strips CC will again be listing all the details for the Phantom Daily and Sunday strips as well as the Mandrake Dailies! Thanks to phan and CC forum member Aman King and his brilliant website <a href='http://www.chroniclechamber.com/2012/02/newspaper-strips-finally-active/' class='excerpt-more'>[...]</a>}
      end
    end

    context "parsing" do
      it "should parse feed document" do
        feed = FilteredFeed::Reader.new.parse(fixture_contents("phantomphorum_sample_feed.xml"))
        feed.url.should == "http://phantomphorum.com/index.php"
        feed.feed_url.should == "http://phantomphorum.com/feed.php"
        feed.title.should == "The Phantom Phorum"
        feed.description.should == "phantomphorum.com"
        feed.last_modified.should be_same_time_as Time.parse("2012-02-11T21:02:15+10:00")

        feed.entries.should have(15).entries
        first_entry = feed.entries.first
        first_entry.author.should == 'pcs'
        first_entry.updated.should be_same_time_as Time.parse("2012-02-11T21:03:55+10:00")
        first_entry.published.should be_same_time_as Time.parse("2012-02-11T21:02:15+10:00")
        first_entry.id.should == "http://phantomphorum.com/viewtopic.php?t=3944&p=62630#p62630"
        first_entry.url.should == "http://phantomphorum.com/viewtopic.php?t=3944&p=62630#p62630"
        first_entry.title.should == "New Phantom Stories • Re: Spoofs on Current Phantom Stories"
        first_entry.categories.should == ["New Phantom Stories"]
        first_entry.content.should == %{<div class="quotetitle">daviedo wrote:</div><div class="quotecontent"><br />This right hand/left hand thing with the Two Rings must give the Phantom problems that Frodo Baggins never dreamed of.<br /></div><br />Very appropriate spoof, considering the ongoing debate  <img src="http://phantomphorum.com/images/smilies/icon_smile.gif" alt=":)" title="Smile" /> . Technically, the Phantom has to mark all evil doers with the  <img src="http://phantomphorum.com/images/smilies/bad_mark.gif" alt=":badmark:" title="Bad Mark" /> mark. For that, he has to use his right fist. In case, he uses his head, or a stick or his feet or anything else to hit a baddie, the  <img src="http://phantomphorum.com/images/smilies/bad_mark.gif" alt=":badmark:" title="Bad Mark" /> mark won't be there. Do you think that to fulfill the  <img src="http://phantomphorum.com/images/smilies/bad_mark.gif" alt=":badmark:" title="Bad Mark" /> mark obligation, he will hit the guy again, even if he is unconscious? <br /><br />Weighty points to ponder upon..<br /><br />pcs<p>Statistics: Posted by <a href="http://phantomphorum.com/memberlist.php?mode=viewprofile&amp;u=243">pcs</a> — Sat 11 Feb, 2012 9:02 pm</p><hr />}
        first_entry.summary.should be_nil
      end
    end

    context "filtering" do
      before :each do
        Feedjira::Feed.should_receive(:fetch_and_parse).with("http://www.somewhere.com/feed.php")
          .and_return(Feedjira::Feed.parse(fixture_contents("phantomphorum_sample_feed.xml")))
      end

      it "should invoke filter on feed fetched" do
        mock_output = mock(:output)
        mock_filter = mock(:filter)
        mock_filter.should_receive(:process).and_return(mock_output)

        FilteredFeed::Reader.new.filter(mock_filter).fetch("http://www.somewhere.com/feed.php").should == mock_output
      end

      it "should chain filters with one's output as next one's input" do
        mock_output1 = mock(:output1)
        mock_filter1 = mock(:filter1)
        mock_filter1.should_receive(:process).and_return(mock_output1)

        mock_output2 = mock(:output2)
        mock_filter2 = mock(:filter2)
        mock_filter2.should_receive(:process).with(mock_output1).and_return(mock_output2)

        FilteredFeed::Reader.new
          .filter(mock_filter1)
          .filter(mock_filter2)
          .fetch("http://www.somewhere.com/feed.php").should == mock_output2
      end
    end
  end
end