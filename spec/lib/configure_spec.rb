require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))

describe Configure do

  before :each do
    @block = Proc.new { }
  end

  describe "#process" do

    before :each do
      described_class.stub(:process_configuration)
    end

    it "should call :process_configuration" do
      described_class.should_receive(:process_configuration).with(Hash, &@block)
      described_class.process &@block
    end

  end

  describe "#process_configuration" do

    before :each do
      @injector = mock described_class::Injector, :configuration => :configuration
      described_class::Injector.stub :new => @injector

      @sandbox = mock described_class::Sandbox, :instance_eval => nil
      described_class::Sandbox.stub :new => @sandbox
    end

    it "should initialize the injector" do
      described_class::Injector.should_receive(:new).with(Hash).and_return(@injector)
      described_class.process_configuration Hash, &@block
    end

    it "should initialize the sandbox" do
      described_class::Sandbox.should_receive(:new).with(@injector).and_return(@sandbox)
      described_class.process_configuration Hash, &@block
    end

    it "should evaluate the block in the sandbox" do
      @sandbox.should_receive(:instance_eval).with(&@block)
      described_class.process_configuration Hash, &@block
    end

    it "should return the configuration" do
      configuration = described_class.process_configuration Hash, &@block
      configuration.should == :configuration
    end

  end

end
