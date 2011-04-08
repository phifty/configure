
# Handler for a single configuration value.
class Configure::Value

  attr_accessor :schema
  attr_accessor :configuration
  attr_accessor :key

  def initialize(schema, configuration, key)
    @schema, @configuration, @key = schema, configuration, key
  end

  def put_single_or_multiple(values)
    self.put_or_combine values.size == 1 ? values.first : values
  end

  def put_or_combine(value)
    existing_value = get
    self.put existing_value.nil? ? value : [ existing_value, value ].flatten
  end

  def put_unless_existing(value)
    self.put value unless exists?
  end

  def put(value)
    check_only_list!
    method_name = :"#{@key}="
    if @configuration.respond_to?(method_name)
      @configuration.send method_name, value
    elsif @configuration.respond_to?(:[]=)
      @configuration[@key] = value
    else
      raise Configure::InvalidKeyError, "couldn't set configuration value for key #{@key}!"
    end
  end

  def get
    check_only_list!
    method_name = :"#{@key}"
    if @configuration.respond_to?(method_name)
      @configuration.send method_name
    elsif @configuration.respond_to?(:[])
      @configuration[@key]
    else
      raise Configure::InvalidKeyError, "couldn't get configuration value for key #{@key}!"
    end
  end

  def exists?
    @configuration.respond_to?(:has_key?) ? @configuration.has_key?(@key) : !!self.get
  end

  private

  def check_only_list!
    raise Configure::InvalidKeyError, "access to set configuration value for key #{@key} denied!" if
      @schema.has_key?(:only) && ![ @schema[:only] ].flatten.include?(@key)
  end

end
