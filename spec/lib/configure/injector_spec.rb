require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))

describe Configure::Injector do

  before :each do
    @injector = described_class.new Hash
  end

  describe "initialize" do

    it "should create a configuration" do
      @injector.configuration.should be_instance_of(Hash)
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
      Configure.should_receive(:process_configuration).with(Hash, &@block).and_return(@nested_configuration)
      @injector.put_block :test_key, @arguments, &@block
    end

    it "should nest the configuration" do
      @injector.put_block :test_key, @arguments, &@block
      @injector.configuration[:test_key].should == @nested_configuration
    end

    it "should set the :arguments key in the nested configuration" do
      @injector.put_block :test_key, @arguments, &@block
      @nested_configuration[:arguments].should == @arguments
    end

    it "should not set the :arguments key in the nested configuration if no arguments are given" do
      @injector.put_block :test_key, [ ], &@block
      @nested_configuration.should_not have_key(:arguments)
    end

    it "should combine nested configurations to an array" do
      @injector.put_block :test_key, @arguments, &@block
      @injector.put_block :test_key, @arguments, &@block
      @injector.configuration[:test_key].should == [ @nested_configuration, @nested_configuration ]
    end

  end

  describe "put_arguments" do

    it "should assign a value" do
      @injector.put_arguments :test_key, [ "one" ]
      @injector.configuration[:test_key].should == "one"
    end

    it "should assign an array of values" do
      @injector.put_arguments :test_key, [ "one", "two" ]
      @injector.configuration[:test_key].should == [ "one", "two" ]
    end

    it "should combine existing with new values" do
      @injector.put_arguments :test_key, [ "one" ]
      @injector.put_arguments :test_key, [ "two" ]
      @injector.configuration[:test_key].should == [ "one", "two" ]
    end

  end

end
