require 'spec_helper'

module FilteredFeed
  describe RegexpExpression do
    context 'extract' do
      it 'should return matching results for regexp with no groups' do
        regexp = RegexpExpression.new("dude\\d+")
        regexp.extract_from("usernames: dude123 dude456 dude678@gmail.com").should == [ "dude123", "dude456", "dude678" ]
      end

      it 'should return matching group results as array of arrays for regexp with groups' do
        regexp = RegexpExpression.new("dude(\\d+)(@\\w+\\.com)?")
        regexp.extract_from("usernames: dude123 dude456 dude678@gmail.com").should == [
          ["123", nil],
          ["456", nil],
          ["678", "@gmail.com"]
        ]
      end

      it 'should return empty result if no match found' do
        regexp = RegexpExpression.new("dude\\d+")
        regexp.extract_from("usernames: abc").should be_empty
      end

      it 'should use to_s representation if source is not string' do
        regexp = RegexpExpression.new("\\d{4}-\\d{2}-\\d{2}")
        regexp.extract_from(Date.parse("2015-03-03")).should == [ "2015-03-03" ]
      end
    end

    context 'replace' do
      it 'should return * in place of matches with no groups' do
        regexp = RegexpExpression.new("dude\\d+")
        regexp.replace_in("usernames: dude123 dude456 dude678@gmail.com").should == "usernames: ******* ******* *******@gmail.com"
      end

      it 'should return * in place of matches with groups' do
        regexp = RegexpExpression.new("dude(\\d+)(@\\w+\\.com)?")
        regexp.replace_in("usernames: dude123 dude456 dude678@gmail.com").should == "usernames: ******* ******* *****************"
      end

      it 'should return without any replacement if no match found' do
        regexp = RegexpExpression.new("dude\\d+")
        regexp.replace_in("usernames: abc").should == "usernames: abc"
      end

      it 'should use to_s representation if source is not string' do
        regexp = RegexpExpression.new("\\d{4}-\\d{2}-\\d{2}")
        regexp.replace_in(Date.parse("2015-03-03")).should == "**********"
      end
    end

    context 'presence' do
      it 'should say present if match found' do
        regexp = RegexpExpression.new("dude\\d+")
        regexp.should be_present_in("usernames: dude123 dude456 dude678@gmail.com")
      end

      it 'should not say present if no match found' do
        regexp = RegexpExpression.new("dude\\d+")
        regexp.should_not be_present_in("usernames: abc")
      end

      it 'should use to_s representation if source is not string' do
        regexp = RegexpExpression.new("\\d{4}-\\d{2}-\\d{2}")
        regexp.should be_present_in(Date.parse("2015-03-03"))
      end
    end

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