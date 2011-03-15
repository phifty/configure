require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))

describe Configure do

  describe "process with schema" do

    before :each do
      @configuration_class = Class.new
      @configuration_class.send :attr_accessor, :test_key
    end

    it "should use the given configuration class to create a configuration instance" do
      schema = {
        :configuration_class => @configuration_class
      }

      configuration = described_class.process schema do
        test_key "one"
      end

      configuration.should be_instance_of(@configuration_class)
      configuration.test_key.should == "one"
    end

  end

end
