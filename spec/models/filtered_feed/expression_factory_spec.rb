require 'spec_helper'

module FilteredFeed
  describe ExpressionFactory do
    it "should return single xpath expression" do
      ExpressionFactory.instance.create(
        { "xpath"=>"//img[@alt=\"Image\"]" }
      ).should == [
        XpathExpression.new("//img[@alt=\"Image\"]")
      ]
    end

    it "should return multiple xpath expressions" do
      ExpressionFactory.instance.create(
        [
          {"xpath"=>"//img[@alt=\"Image\"]"},
          {"xpath"=>"//a[contains(@href, \"http://www.youtube.com\")]"}
        ]
      ).should == [
        XpathExpression.new("//img[@alt=\"Image\"]"),
        XpathExpression.new("//a[contains(@href, \"http://www.youtube.com\")]")
      ]
    end

    it "should return single regexp expression" do
      ExpressionFactory.instance.create(
        { "regexp"=>"[?&]?t=2323&?" }
      ).should == [
        RegexpExpression.new("[?&]?t=2323&?")
      ]
    end

    it "should return single regexp expression that represents a string" do
      ExpressionFactory.instance.create(
        "[ something nasty? ]"
      ).should == [
        RegexpExpression.new(Regexp.escape("[ something nasty? ]"))
      ]
    end

    it "should return multiple regexp expressions" do
      ExpressionFactory.instance.create(
        [
          {"regexp"=>"[?&]?t=2323&?"},
          {"regexp"=>"(\\?|&)?p=2323&?"}
        ]
      ).should == [
        RegexpExpression.new("[?&]?t=2323&?"),
        RegexpExpression.new("(\\?|&)?p=2323&?")
      ]
    end

    it "should return an xpath expression and a regexp expression" do
      ExpressionFactory.instance.create(
        [
          {"xpath"=>"//img[@alt=\"Image\"]"},
          "[ something nasty? ]"
        ]
      ).should == [
        XpathExpression.new("//img[@alt=\"Image\"]"),
        RegexpExpression.new(Regexp.escape("[ something nasty? ]"))
      ]
    end
  end
end