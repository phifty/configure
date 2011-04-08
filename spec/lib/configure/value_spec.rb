require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))

describe Configure::Value do

  before :each do
    @schema = { :only => :test }
    @configuration = { }

    @value = described_class.new @schema, @configuration, :test
  end

  describe "#put_single_or_multiple" do

    before :each do
      @value.stub :put_or_combine => nil
    end

    it "should call :put_or_combine with a single value" do
      @value.should_receive(:put_or_combine).with(:value)
      @value.put_single_or_multiple [ :value ]
    end

    it "should call :put_or_combine with a multiple values" do
      @value.should_receive(:put_or_combine).with([ :value_one, :value_two ])
      @value.put_single_or_multiple [ :value_one, :value_two ]
    end

  end

  describe "#put_or_combine" do

    before :each do
      @value.stub :put => nil
      @value.stub :get => :test
    end

    it "should call :put with the argument combined with the existing value if it's existing" do
      @value.should_receive(:put).with([ :test, :value ])
      @value.put_or_combine :value
    end

    it "should call :put with the argument if no value is existing" do
      @value.stub :get => nil
      @value.should_receive(:put).with(:value)
      @value.put_or_combine :value
    end

  end

  describe "#put_unless_existing" do

    before :each do
      @value.stub :put => nil
    end

    it "should call :put with the argument if the value isn't existing" do
      @value.should_receive(:put).with(:value)
      @value.put_unless_existing :value
    end

    it "should not call :put with the argument if the value is existing" do
      @configuration[:test] = nil
      @value.should_not_receive(:put)
      @value.put_unless_existing :value
    end

  end

  describe "#put" do

    it "should set the configuration value" do
      @value.put :value
      @configuration[:test].should == :value
    end

    it "should raise an #{Configure::InvalidKeyError} if the key isn't included in only-list" do
      @value.key = :invalid
      lambda do
        @value.put :value
      end.should raise_error(Configure::InvalidKeyError)
    end

    it "should raise an #{Configure::InvalidKeyError} if the value can't be set" do
      @value.configuration = Object.new
      lambda do
        @value.put :value
      end.should raise_error(Configure::InvalidKeyError)
    end

  end

  describe "#get" do

    before :each do
      @configuration[:test] = :value
    end

    it "should set the configuration value" do
      value = @value.get
      value.should == :value
    end

    it "should raise an #{Configure::InvalidKeyError} if the key isn't included in only-list" do
      @value.key = :invalid
      lambda do
        @value.get
      end.should raise_error(Configure::InvalidKeyError)
    end

    it "should raise an #{Configure::InvalidKeyError} if the value can't be set" do
      @value.configuration = Object.new
      lambda do
        @value.get
      end.should raise_error(Configure::InvalidKeyError)
    end

  end

  describe "#exists?" do

    before :each do
      @configuration[:test] = :value
      @value.stub :get => :value
    end

    it "should return true" do
      exists = @value.exists?
      exists.should be_true
    end

    it "should return true if key is existing, but value is nil" do
      @configuration[:test] = nil
      exists = @value.exists?
      exists.should be_true
    end

    it "should return false if key isn't existing" do
      @configuration.delete :test
      exists = @value.exists?
      exists.should be_false
    end

    it "should check just the value if configuration doesn't respond to :has_key?" do
      @configuration.stub :respond_to? => false
      exists = @value.exists?
      exists.should be_true
    end

  end

end
