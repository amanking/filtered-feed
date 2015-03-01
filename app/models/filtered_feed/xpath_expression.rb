module FilteredFeed
  class XpathExpression
    include AttributeDriven
    equality_based_on :xpath

    def initialize(xpath)
      @xpath = xpath
    end

    def extract_from(source)
      matching_nodes_in(source).collect(&:to_xhtml)
    end

    def replace_in(source)
      result = Nokogiri::HTML::DocumentFragment.parse(source.to_s).to_xhtml
      matching_nodes_in(source).each do |node|
        result.sub!(/\s*#{Regexp.escape(node.to_xhtml)}\s*/, ' ' + replacement(node) + ' ')
      end
      result
    end

    def present_in?(source)
      matching_nodes_in(source).present?
    end

  private
    def matching_nodes_in(source)
      Nokogiri::HTML(source.to_s).xpath(@xpath)
    end

    def replacement(node)
      case node.name
      when "img" then strikethrough("image")
      when "a" then strikethrough("link")
      else ""
      end
    end

    def strikethrough(text)
      "<span style=\"text-decoration:line-through\">&nbsp;&nbsp;#{text}&nbsp;&nbsp;</span>"
    end
  end
end