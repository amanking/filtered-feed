require 'spec_helper'

module FilteredFeed
  describe RegexpExpression do
    context "regexp with options (between %% in the end)" do

      it "should pass on ignorecase option" do
        regexp = RegexpExpression.new("blah%i%")
        regexp.send(:regexp).should == /blah/i
        regexp.should be_present_in("BLaH")
      end

      it "should pass on multiline option" do
        regexp = RegexpExpression.new("blah%m%")
        regexp.send(:regexp).should == /blah/m
        regexp.should be_present_in("hi\nblah")
      end

      it "should pass on extended option" do
        regexp = RegexpExpression.new("blah%x%")
        regexp.send(:regexp).should == /blah/x
      end

      it "should pass on combination of options" do
        regexp = RegexpExpression.new("blah%im%")
        regexp.send(:regexp).should == /blah/im
        regexp.should be_present_in("hi\nBLaH")
      end

      it "should consider %% as part of string, if invalid options within" do
        RegexpExpression.new("blah%abc%").send(:regexp).should == /blah%abc%/
        RegexpExpression.new("blah%aim%").send(:regexp).should == /blah%aim%/
        RegexpExpression.new("blah%immm%").send(:regexp).should == /blah%immm%/
      end

      it "should consider %% as part of string even if valid options present but not at end of string" do
        RegexpExpression.new("blah%i%me").send(:regexp).should == /blah%i%me/
        RegexpExpression.new("blah%im%me").send(:regexp).should == /blah%im%me/
        RegexpExpression.new("%i%blahme").send(:regexp).should == /%i%blahme/
      end
    end
  end
end