require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))

describe Configure::Sandbox do

  before :each do
    @injector = mock Configure::Injector, :put_arguments => nil, :put_block => nil
    @sandbox = described_class.new @injector
  end

  it "should pass method calls without a block to the injector's :put_arguments" do
    @injector.should_receive(:put_arguments).with(:test_key, [ "value" ])
    @sandbox.test_key "value"
  end

  it "should pass method calls with a block to the injector's :put_block" do
    block = Proc.new { }
    @injector.should_receive(:put_block).with(:test_key, &block)
    @sandbox.test_key &block
  end

end
