require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))

describe Configure do

  describe "process without schema" do

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

    it "should combine nested configurations to an array" do
      configuration = described_class.process do
        test_key do
          nested_test_key "one"
        end
        test_key do
          nested_test_key "two"
        end
      end

      configuration.should == {
        :test_key => [
          { :nested_test_key => "one" },
          { :nested_test_key => "two" }
        ]
      }
    end

    it "should set the :arguments key in nested configurations with the passed arguments" do
      configuration = described_class.process do
        test_key "one", "two" do
          nested_test_key "three"
        end
      end

      configuration.should == {
        :test_key => { :arguments => [ "one", "two" ], :nested_test_key => "three" }
      }
    end

    it "should take nil values" do
      configuration = described_class.process do
        test_key nil
      end

      configuration.should == {
        :test_key => nil
      }
    end

  end

end
