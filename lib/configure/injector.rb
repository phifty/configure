
# Creates a configuration from the passed class and provides methods to inject values.
class Configure::Injector

  attr_reader :schema

  def initialize(schema)
    @schema = schema
    @configuration = self.configuration_class.new
  end

  def configuration_class
    @schema[:configuration_class]
  end

  def defaults
    @schema[:defaults] || { }
  end

  def put_block(key, arguments, &block)
    nested_schema = (@schema[:nested] || { })[key] || @schema[:nested_default] || Configure::Schema.build { }
    nested_configuration = Configure.process_configuration nested_schema, &block
    Arguments.new(nested_schema, nested_configuration, arguments).put
    value = Configure::Value.new @schema, @configuration, key
    value.put_or_combine nested_configuration
  end

  def put_arguments(key, arguments)
    value = Configure::Value.new @schema, @configuration, key
    value.put_single_or_multiple arguments
  end

  def configuration
    apply_defaults
    @configuration
  end

  private

  def apply_defaults
    self.defaults.each do |key, default_value|
      value = Configure::Value.new @schema, @configuration, key
      value.put_unless_existing default_value
    end
  end

  # Injector for the arguments in a nested configuration.
  class Arguments

    def initialize(schema, configuration, arguments)
      @schema, @configuration, @arguments = schema, configuration, arguments.dup
    end

    def put
      put_to_specified_keys
      put_to_argument_key
      check_values!
    end

    private

    def put_to_specified_keys
      return if @arguments.empty?
      argument_keys = [ @schema[:argument_keys] ].flatten.compact
      argument_keys.each do |argument_key|
        arguments_value = Configure::Value.new @schema, @configuration, argument_key
        arguments_value.put @arguments.shift
      end
    end

    def put_to_argument_key
      return if @arguments.empty?
      arguments_value = Configure::Value.new @schema, @configuration, :arguments
      arguments_value.put @arguments
    end

    def check_values!
      Configure::Checker.new(@schema, @configuration).check!
    end

  end

end
