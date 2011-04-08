require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))

describe Configure::Checker do

  before :each do
    @schema = {
      :not_nil => [ :test ]
    }
    @configuration = { }

    @checker = described_class.new @schema, @configuration
  end

  describe "#check!" do

    before :each do
      @value = mock Configure::Value, :get => "value"
      Configure::Value.stub :new => @value
    end

    it "should initialize #{Configure::Value}" do
      Configure::Value.should_receive(:new).with(@schema, @configuration, :test).and_return(@value)
      @checker.check!
    end

    it "should not raise any error" do
      lambda do
        @checker.check!
      end.should_not raise_error
    end

    it "should raise a #{Configure::NilValueError} if value is nil" do
      @value.stub :get => nil
      lambda do
        @checker.check!
      end.should raise_error(Configure::NilValueError)
    end

  end

end
