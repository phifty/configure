
# Creates a configuration from the passed class and provides methods to inject values.
class Configure::Injector

  attr_reader :configuration

  def initialize(configuration_class)
    @configuration_class = configuration_class
    @configuration = @configuration_class.new
  end

  def put_block(key, &block)
    @configuration[key] = Configure.process_configuration @configuration_class, &block
  end

  def put_arguments(key, arguments)
    value = arguments.size == 1 ? arguments.first : arguments
    @configuration[key] = @configuration.has_key?(key) ? [ @configuration[key], value ].flatten : value
  end

end
