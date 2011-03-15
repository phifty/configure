require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))

describe Configure::Injector do

  before :each do
    @configuration_class = Class.new
    @configuration_class.send :attr_accessor, :test_key
    @configuration_class.send :attr_accessor, :another_test_key

    @nested_schema = { }
    @schema = {
      :configuration_class => @configuration_class,
      :nested => {
        :test_key => @nested_schema
      },
      :defaults => {
        :another_test_key => "default value"
      }
    }
    @injector = described_class.new @schema
  end

  describe "initialize" do

    it "should create a configuration" do
      configuration = @injector.configuration
      configuration.should be_instance_of(@schema[:configuration_class])
    end

    it "should set the default values" do
      configuration = @injector.configuration
      configuration.another_test_key.should == "default value"
    end

  end

  describe "put_block" do

    before :each do
      @block = Proc.new { }
      @arguments = [ "one" ]
      @nested_configuration = { }
      Configure.stub(:process_configuration => @nested_configuration)
    end

    it "should process a new (nested) configuration" do
      Configure.should_receive(:process_configuration).with(@nested_schema, &@block).and_return(@nested_configuration)
      @injector.put_block :test_key, @arguments, &@block
    end

    it "should nest the configuration" do
      @injector.put_block :test_key, @arguments, &@block
      @injector.configuration.test_key.should == @nested_configuration
    end

    it "should set the :arguments key in the nested configuration" do
      @injector.put_block :test_key, @arguments, &@block
      @injector.configuration.test_key[:arguments].should == @arguments
    end

    it "should not set the :arguments key in the nested configuration if no arguments are given" do
      @injector.put_block :test_key, [ ], &@block
      @injector.configuration.test_key.should_not have_key(:arguments)
    end

    it "should set the :argument_keys with the argument values if specified" do
      @injector.schema[:nested][:test_key][:argument_keys] = :another_test_key
      @injector.put_block :test_key, @arguments, &@block
      @injector.configuration.test_key[:another_test_key].should == "one"
    end

    it "should combine nested configurations to an array" do
      @injector.put_block :test_key, @arguments, &@block
      @injector.put_block :test_key, @arguments, &@block
      @injector.configuration.test_key.should == [ @nested_configuration, @nested_configuration ]
    end

  end

  describe "put_arguments" do

    it "should assign a value" do
      @injector.put_arguments :test_key, [ "one" ]
      @injector.configuration.test_key.should == "one"
    end

    it "should override a value" do
      @injector.put_arguments :another_test_key, [ "one" ]
      @injector.configuration.another_test_key.should == "one"
    end

    it "should assign an array of values" do
      @injector.put_arguments :test_key, [ "one", "two" ]
      @injector.configuration.test_key.should == [ "one", "two" ]
    end

    it "should combine existing with new values" do
      @injector.put_arguments :test_key, [ "one" ]
      @injector.put_arguments :test_key, [ "two" ]
      @injector.configuration.test_key.should == [ "one", "two" ]
    end

    it "should raise a #{described_class::Error} if key can't be set" do
      lambda do
        @injector.put_arguments :invalid_key, [ "one" ]
      end.should raise_error(described_class::Error)
    end

  end

  describe "configuration" do

    before :each do
      @injector.put_arguments :test_key, [ "one" ]
    end

    it "should return an instance of :configuration_class" do
      configuration = @injector.configuration
      configuration.should be_instance_of(@schema[:configuration_class])
    end

  end

end
