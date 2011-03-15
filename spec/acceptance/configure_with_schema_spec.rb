require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))

describe Configure do

  describe "process with schema" do

    before :each do
      @configuration_class = Class.new
      @configuration_class.send :attr_accessor, :test_key_one

      configuration_class = @configuration_class
      @schema = described_class::Schema.build do
        configuration_class configuration_class
      end
    end

    it "should use the given configuration class to create a configuration instance" do
      configuration = described_class.process @schema do
        test_key_one "one"
      end

      configuration.should be_instance_of(@configuration_class)
      configuration.test_key_one.should == "one"
    end

  end

end
