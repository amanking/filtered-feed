require 'spec_helper'

module FilteredFeed
  describe XpathExpression do
    context 'extract' do
      it 'should return matching results for xpath' do
        xpath = XpathExpression.new(%{//img[@alt="Image"]})
        xpath.extract_from(%{I love <img src="218.png" alt="Image" />, <img src="219.png" alt="Icon" />, and <img src="220.png" alt="Image" />})
          .should == [ %{<img src="218.png" alt="Image" />}, %{<img src="220.png" alt="Image" />} ]
      end

      it 'should return empty result if no match found' do
        xpath = XpathExpression.new(%{//img[@alt="Image"]})
        xpath.extract_from("I love nothing!").should be_empty
      end

      it 'should use to_s representation if source is not string' do
        xpath = XpathExpression.new(%{//img[@alt="Image"]})
        xpath.extract_from(Nokogiri::HTML::DocumentFragment.parse(%{I love <img src="218.png" alt="Image" />}))
          .should == [ %{<img src="218.png" alt="Image" />} ]
      end
    end

    context 'replace' do
      it 'should return --image-- in place of image xpath matches' do
        xpath = XpathExpression.new(%{//img[@alt="Image"]})
        xpath.replace_in(%{I love <img src="218.png" alt="Image" /> <img src="219.png" alt="Icon" /> <img src="220.png" alt="Image" />})
          .should == %{I love <span style="text-decoration:line-through">&nbsp;&nbsp;image&nbsp;&nbsp;</span> <img src="219.png" alt="Icon" /> <span style="text-decoration:line-through">&nbsp;&nbsp;image&nbsp;&nbsp;</span> }
      end

      it 'should return --link-- in place of anchor xpath matches' do
        xpath = XpathExpression.new(%{//a[@href="/batman.html"]})
        xpath.replace_in(%{I love <a href="/batman.html">The Batman</a> and <a href="/phantom.html">The Phantom</a>})
          .should == %{I love <span style="text-decoration:line-through">&nbsp;&nbsp;link&nbsp;&nbsp;</span> and <a href="/phantom.html">The Phantom</a>}
      end

      it 'should return blank in place of other xpath matches' do
        xpath = XpathExpression.new(%{//br})
        xpath.replace_in(%{I love The Batman<br/> and The Phantom})
          .should == %{I love The Batman  and The Phantom}
      end

      it 'should return without any replacement if no match found' do
        xpath = XpathExpression.new(%{//img[@alt="Image"]})
        xpath.replace_in("I love nothing!").should == "I love nothing!"
      end

      it 'should use to_s representation if source is not string' do
        xpath = XpathExpression.new(%{//img[@alt="Image"]})
        xpath.replace_in(Nokogiri::HTML::DocumentFragment.parse(%{I love <img src="218.png" alt="Image" />}))
          .should == %{I love <span style="text-decoration:line-through">&nbsp;&nbsp;image&nbsp;&nbsp;</span> }
      end
    end

    context 'presence' do
      it 'should say present if match found' do
        xpath = XpathExpression.new(%{//img[@alt="Image"]})
        xpath.should be_present_in(%{I love <img src="218.png" alt="Image" /> <img src="219.png" alt="Icon" /> <img src="220.png" alt="Image" />})
      end

      it 'should not say present if no match found' do
        xpath = XpathExpression.new(%{//img[@alt="Image"]})
        xpath.should_not be_present_in("I love nothing!")
      end

      it 'should use to_s representation if source is not string' do
        xpath = XpathExpression.new(%{//img[@alt="Image"]})
        xpath.should be_present_in(Nokogiri::HTML::DocumentFragment.parse(%{I love <img src="218.png" alt="Image" />}))
      end
    end
  end
end