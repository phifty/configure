require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))

describe Configure::Schema do

  describe "#self.build" do

    before :each do
      @block = Proc.new { }
      Configure.stub(:process)
    end

    it "should use configure to build the schema hash" do
      Configure.should_receive(:process).with(described_class::SCHEMA, &@block)
      described_class.build &@block
    end

  end

end
