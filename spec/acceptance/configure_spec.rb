require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))

describe Configure do

  describe "process" do

    it "should turn method call into hash values" do
      configuration = described_class.process do
        test_key "one"
      end

      configuration.should == {
        :test_key => "one"
      }
    end

    it "should combine multiple arguments to an array" do
      configuration = described_class.process do
        test_key "one", "two"
      end

      configuration.should == {
        :test_key => [ "one", "two" ]
      }
    end

    it "should combine the values of multiple calls to an array" do
      configuration = described_class.process do
        test_key "one", "two"
        test_key "three", "four"
      end

      configuration.should == {
        :test_key => [ "one", "two", "three", "four" ]
      }
    end

    it "should build nested configurations out of the passed blocks" do
      configuration = described_class.process do
        test_key do
          nested_test_key "one"
        end
      end

      configuration.should == {
        :test_key => { :nested_test_key => "one" }
      }
    end

  end

end