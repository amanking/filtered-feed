require 'spec_helper'

describe FeedItemsController do
  before(:each) do
    controller.stub(:cache_result).and_yield
  end

  it 'should fetch feed and apply specified filters' do
    stub_request(:get, "http://www.somewhere.com/feed.php")
      .to_return(:body => fixture_contents("phantomphorum_sample_feed.xml"))

    get :index, {
        source: 'http://www.somewhere.com/feed.php',
        replace: {
            content: [
                { xpath: '//hr' },
                { xpath: '//br' }
            ]
        },
        extract: {
            published: { regexp: '\\d{4}-\\d{2}-\\d{2}[T\\s](?:\\d{2}:?){3}' }
        },
        exclude: {
            content: { regexp: 'the Francis Blake affair%i%' },
            id: 'http://phantomphorum.com/viewtopic.php?t=3944&amp;p=62629#p62629'
        }
    }

    response.should be_success

    json_hash = JSON.parse(response.body)
    json_hash_entries = json_hash["entries"]
    json_hash_entries.should have(13).entries

    mapped_attributes(json_hash_entries, "id").should_not include('http://phantomphorum.com/viewtopic.php?t=3944&amp;p=62629#p62629')
    mapped_attributes(json_hash_entries, "content").should be_none { |content| content.include?('The Francis Blake Affair') }
    mapped_attributes(json_hash_entries, "published").should be_all { |published| published =~ /\A\d{4}-\d{2}-\d{2}[T\s](?:\d{2}:?){3}\Z/ }
    mapped_attributes(json_hash_entries, "content").should be_none { |content| content =~ /<[hb]r\s*?\/?\s*?>/ }
  end

  it 'should follow redirects (at most 5 times) to fetch feed' do
    stub_request_with_intermediate_redirects(5, "http://www.somewhere.com/feed.php", fixture_contents("phantomphorum_sample_feed.xml"))

    get :index, source: 'http://www.somewhere.com/feed.php'

    response.should be_success

    json_hash = JSON.parse(response.body)
    json_hash_entries = json_hash["entries"]
    json_hash_entries.should have(15).entries
  end

  it 'should raise error if redirection is more than 5 times while fetching feed' do
    stub_request_with_intermediate_redirects(6, "http://www.somewhere.com/feed.php", fixture_contents("phantomphorum_sample_feed.xml"))

    lambda {
      get :index, source: 'http://www.somewhere.com/feed.php'
    }.should raise_error('HTTP redirect too deep')
  end

  it 'should raise error if error in fetching source' do
    stub_request(:get, "http://www.somewhere.com/feed.php")
      .to_return(:status => 500)

    lambda {
      get :index, source: 'http://www.somewhere.com/feed.php'
    }.should raise_error
  end

  it 'should set no cache headers' do
    stub_request(:get, "http://www.somewhere.com/feed.php")
      .to_return(:body => fixture_contents("phantomphorum_sample_feed.xml"))

    get :index, source: 'http://www.somewhere.com/feed.php'

    response.headers.should include({
      "Cache-Control" => "no-cache, no-store, max-age=0, must-revalidate",
      "Pragma" => "no-cache",
      "Expires" => "Fri, 01 Jan 1990 00:00:00 GMT"
    })
  end

  it 'should return 400 if no source specified' do
    get :index

    response.status.should == 400
    response.body.should be_blank
  end

  def mapped_attributes(json_hash_entries, attribute)
    json_hash_entries.map {|entry| entry[attribute] }
  end

  def stub_request_with_intermediate_redirects(redirect_count, source, body)
    redirect_count.times do |i|
      stub_request(:get, source.gsub('www', "www#{i == 0 ? '' : i}"))
        .to_return(:status => 302, :headers => { "Location" => source.gsub('www', "www#{i + 1}") })
    end

    stub_request(:get, source.gsub('www', "www#{redirect_count}"))
      .to_return(:body => body)
  end
end