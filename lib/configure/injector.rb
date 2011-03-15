
# Creates a configuration from the passed class and provides methods to inject values.
class Configure::Injector

  # The error will be raised if the configuration value can't be set or get.
  class Error < StandardError; end

  attr_reader :schema

  def initialize(schema)
    @schema = schema
  end

  def configuration_class
    @schema[:configuration_class] || Hash
  end

  def configuration
    @configuration ||= self.configuration_class.new
  end

  def put_block(key, arguments, &block)
    nested_configuration = Configure.process_configuration self.schema[key] || { }, &block
    self.class.put_nested_arguments nested_configuration, arguments
    value = Value.new self.configuration, key
    value.put_or_combine nested_configuration
  end

  def put_arguments(key, arguments)
    value = Value.new self.configuration, key
    value.put_single_or_multiple arguments
  end

  private

  def self.put_nested_arguments(nested_configuration, arguments)
    return if arguments.empty?
    arguments_value = Value.new nested_configuration, :arguments
    arguments_value.put_or_combine arguments
  end

  # Injector for a single configuration value.
  class Value

    def initialize(configuration, key)
      @configuration, @key = configuration, key
    end

    def put_single_or_multiple(values)
      self.put_or_combine values.size == 1 ? values.first : values
    end

    def put_or_combine(value)
      self.put exists? ? [ get, value ].flatten : value
    end

    def put(value)
      method_name = :"#{@key}="
      if @configuration.respond_to?(method_name)
        @configuration.send method_name, value
      elsif @configuration.respond_to?(:[]=)
        @configuration[@key] = value
      else
        raise Error, "couldn't set configuration value for key #{@key}!"
      end
    end

    def get
      method_name = :"#{@key}"
      if @configuration.respond_to?(method_name)
        @configuration.send method_name
      elsif @configuration.respond_to?(:[])
        @configuration[@key]
      else
        raise Error, "couldn't get configuration value for key #{@key}!"
      end
    end

    def exists?
      !!self.get
    end

  end

end
