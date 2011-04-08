
module Configure::Schema

  SCHEMA = {
    :configuration_class => Hash,
    :only => [
      :configuration_class,
      :only,
      :not_nil,
      :argument_keys,
      :defaults,
      :nested_default,
      :nested
    ],
    :not_nil => [
      :configuration_class
    ],
    :defaults => {
      :configuration_class => Hash
    },
    :nested => {
      :nested => {
        :configuration_class => Hash
      }
    }
  }
  SCHEMA[:nested][:nested][:nested_default] = SCHEMA
  SCHEMA.freeze

  def self.build(&block)
    Configure.process SCHEMA, &block
  end

end
