
# Creates a configuration from the passed class and provides methods to inject values.
class Configure::Injector

  attr_reader :configuration

  def initialize(configuration_class)
    @configuration_class = configuration_class
    @configuration = @configuration_class.new
  end

  def put_block(key, arguments, &block)
    nested_configuration = Configure.process_configuration @configuration_class, &block
    self.class.put_nested_arguments nested_configuration, arguments
    value = Value.new @configuration, key
    value.put nested_configuration
  end

  def put_arguments(key, arguments)
    value = Value.new @configuration, key
    value.put_single_or_multiple arguments
  end

  private

  def self.put_nested_arguments(nested_configuration, arguments)
    return if arguments.empty?
    arguments_value = Value.new nested_configuration, :arguments
    arguments_value.put arguments
  end

  # Injector for a single configuration value.
  class Value

    def initialize(configuration, key)
      @configuration, @key = configuration, key
    end

    def get
      @configuration[@key]
    end

    def put(value)
      @configuration[@key] = exists? ? [ get, value ].flatten : value
    end

    def put_single_or_multiple(values)
      self.put values.size == 1 ? values.first : values
    end

    def exists?
      @configuration.has_key? @key
    end

  end

end
