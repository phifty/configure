require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))

describe Configure::Schema do

  describe "build" do

    before :each do
      @block = Proc.new {
        configuration_class Hash
        nested {
          test_key_one {
            only :test_key_two
          }
        }
      }
    end

    it "should return a hash with the schema" do
      schema = described_class.build &@block
      schema.should == {
        :configuration_class => Hash,
        :nested => {
          :test_key_one => {
            :configuration_class => Hash,
            :only => :test_key_two
          }
        }
      }
    end

    it "should raise an #{Configure::InvalidKeyError} if an invalid schema key is given" do
      lambda do
        described_class.build {
          invalid :value
        }
      end.should raise_error(Configure::InvalidKeyError)
    end

    it "should raise an #{Configure::InvalidKeyError} if an invalid nested schema key is given" do
      lambda do
        described_class.build {
          nested {
            test_key_one {
              invalid :value
            }
          }
        }
      end.should raise_error(Configure::InvalidKeyError)
    end

  end

end
