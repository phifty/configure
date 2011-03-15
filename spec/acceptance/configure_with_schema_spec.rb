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
        defaults do
          test_key_one "default value"
        end
        nested do
          test_key_two do
            defaults do
              test_key_three "default value"
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
        :test_key_three => "default value"
      }
    end

  end

end
