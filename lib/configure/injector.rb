
# Creates a configuration from the passed class and provides methods to inject values.
class Configure::Injector

  attr_reader :configuration

  def initialize(configuration_class)
    @configuration_class = configuration_class
    @configuration = @configuration_class.new
  end

  def put_block(key, &block)
    value = Value.new @configuration, key
    value.put Configure.process_configuration(@configuration_class, &block)
  end

  def put_arguments(key, arguments)
    value = Value.new @configuration, key
    value.put arguments.size == 1 ? arguments.first : arguments
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

    def exists?
      @configuration.has_key? @key
    end

  end

end
