require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))

describe Configure do

  before :each do
    @block = Proc.new { }
  end

  describe "#process" do

    before :each do
      described_class::Schema.stub :build => :schema
      described_class.stub :process_configuration => nil
    end

    it "should build an empty schema if none given" do
      described_class::Schema.should_receive(:build).and_return(:schema)
      described_class.process nil, &@block
    end

    it "should call :process_configuration" do
      described_class.should_receive(:process_configuration).with(:schema, &@block)
      described_class.process :schema, &@block
    end

  end

  describe "#process_configuration" do

    before :each do
      @injector = mock described_class::Injector, :configuration => :configuration
      described_class::Injector.stub :new => @injector

      @sandbox = mock described_class::Sandbox, :instance_eval => nil
      described_class::Sandbox.stub :new => @sandbox

      @checker = mock described_class::Checker, :check! => nil
      described_class::Checker.stub :new => @checker
    end

    it "should initialize the injector" do
      described_class::Injector.should_receive(:new).with(:schema).and_return(@injector)
      described_class.process_configuration :schema, &@block
    end

    it "should initialize the sandbox" do
      described_class::Sandbox.should_receive(:new).with(@injector).and_return(@sandbox)
      described_class.process_configuration :schema, &@block
    end

    it "should evaluate the block in the sandbox" do
      @sandbox.should_receive(:instance_eval).with(&@block)
      described_class.process_configuration :schema, &@block
    end

    it "should initialize the checker" do
      described_class::Checker.should_receive(:new).with(:schema, :configuration).and_return(@checker)
      described_class.process_configuration :schema, &@block
    end

    it "should check the configuration values" do
      @checker.should_receive(:check!)
      described_class.process_configuration :schema, &@block
    end

    it "should return the configuration" do
      configuration = described_class.process_configuration :schema, &@block
      configuration.should == :configuration
    end

  end

end
