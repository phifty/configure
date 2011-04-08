require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))

describe Configure do

  describe "process with schema" do

    before :each do
      @configuration_class = Class.new
      @configuration_class.send :attr_accessor, :test_key_one
      @configuration_class.send :attr_accessor, :test_key_two

      configuration_class = @configuration_class
      @schema = described_class::Schema.build do
        configuration_class configuration_class
        only :test_key_one, :test_key_two, :test_key_three, :test_key_four, :test_key_five
        not_nil :test_key_one
        defaults do
          test_key_one "default value"
        end
        nested do
          test_key_two do
            argument_keys :test_key_three, :test_key_four
            defaults do
              test_key_five "default value"
            end
          end
        end
      end
    end

    it "should use the specified configuration class to create a configuration instance" do
      configuration = described_class.process @schema do

      end

      configuration.should be_instance_of(@configuration_class)
    end

    it "should inject the given values" do
      configuration = described_class.process @schema do
        test_key_one "one"
      end

      configuration.test_key_one.should == "one"
    end

    it "should raise an #{Configure::InvalidKeyError} if key isn't included in :only list" do
      lambda do
        described_class.process @schema do
          test_key_six "six"
        end
      end.should raise_error(Configure::InvalidKeyError)
    end

    it "should use the specified default values" do
      configuration = described_class.process @schema do

      end

      configuration.test_key_one.should == "default value"
    end

    it "should evaluate the default values in nested schemas" do
      configuration = described_class.process @schema do
        test_key_two do

        end
      end

      configuration.test_key_two.should == {
        :test_key_five => "default value"
      }
    end

    it "should transfer the arguments to a nested configuration to the specified argument_keys" do
      configuration = described_class.process @schema do
        test_key_two "three", "four" do
          test_key_five "five"
        end
      end

      configuration.test_key_two.should == {
        :test_key_three => "three",
        :test_key_four => "four",
        :test_key_five => "five"
      }
    end

    it "should transfer the argument-rest to a nested :arguments key" do
      configuration = described_class.process @schema do
        test_key_two "three", "four", "extra" do
          test_key_five "five"
        end
      end

      configuration.test_key_two.should == {
        :test_key_three => "three",
        :test_key_four => "four",
        :test_key_five => "five",
        :arguments => [ "extra" ]
      }
    end

  end

end
