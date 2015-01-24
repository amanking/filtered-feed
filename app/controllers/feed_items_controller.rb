require 'net/http'

class FeedItemsController < ApplicationController
  include Caching::FileCache

  before_filter :set_no_cache_headers

  KNOWN_FILTER_TYPES = [:exclude, :extract, :replace]

  def index
    unless params[:source]
      render :nothing => true, status: 400
      return
    end
    render :json => feed_reader.parse(feed_document), :callback => params[:callback]
  end

  private

  def feed_document
    feed_source = params[:source]
    cache_result(:filename => "#{Base64.urlsafe_encode64(feed_source)[0,100]}.xml", :expires => 15.minutes) do
      fetch_http_response_body(feed_source)
    end
  end

  def fetch_http_response_body(feed_source)
    url = URI.parse(feed_source)
    req = Net::HTTP::Get.new(url.request_uri)
    res = Net::HTTP.start(url.host, url.port, :use_ssl => (url.scheme == 'https')) { |http| http.request(req) }
    res.body
  end

  def feed_reader
    specified_filters.compact.inject(FilteredFeed::Reader.new) do |reader, filter|
      reader.filter(filter)
    end
  end

  def specified_filters
    specified_filter_types = KNOWN_FILTER_TYPES & params.keys.collect(&:to_sym)
    specified_filter_types.collect_concat {|specified_filter_type| filters_for(specified_filter_type) }
  end

  def filters_for(filter_type)
    fitler_params(filter_type).collect do |filter_on, expression_specifications|
      filter_class(filter_type).new(filter_on, *filter_expressions(expression_specifications))
    end
  end

  def fitler_params(filter_type)
    params[filter_type].inject({}) do |result, (filter_on, expression_specifications)|
      result[filter_on] = convert_to_expression_specifications(expression_specifications)
      result
    end
  end

  def convert_to_expression_specifications(expression_specifications)
    return expression_specifications if expression_specifications.is_a?(String)
    return expression_specifications if expression_specifications.is_a?(Array)
    return expression_specifications if expression_specifications.is_a?(Hash) && expression_specifications.keys.none? {|key| key =~ /^\d+$/}
    expression_specifications.values
  end

  def filter_class(filter_type)
    "FilteredFeed::#{filter_type.to_s.camelize}Filter".constantize
  end

  def filter_expressions(expression_specifications)
    FilteredFeed::ExpressionFactory.instance.create(expression_specifications)
  end

  def set_no_cache_headers
    response.headers["Cache-Control"] = "no-cache"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

end