require 'spec_helper'

module Mixins
  module CustomSerialization
    describe ToHash do
      before(:each) do
        @klass = Struct.new(:name, :url, :age) do
          include CustomSerialization::ToHash

          def attributes
            result = {}
            each_pair {|key, value| result[key] = value}
            result
          end
        end
      end

      it "should return hash with mentioned attribute values" do
        @klass.new('bruce', 'http://google.com', 32).to_hash(:name, :age).should == {
            :name => 'bruce',
            :age => 32
        }
      end

      it "should return hash with all attributes if nothing mentioned" do
        @klass.new('bruce', 'http://google.com', 32).to_hash.should == {
            :name => 'bruce',
            :url => 'http://google.com',
            :age => 32
        }
      end

      it "should bomb if an attribute not found" do
        lambda { @klass.new('bruce', 'http://google.com', 32).to_hash(:name, :blah) }.should raise_error(NoMethodError)
      end
    end
  end
end
