
# Checks the value against nil.
class Configure::Checker

  attr_accessor :schema
  attr_accessor :configuration

  def initialize(schema, configuration)
    @schema, @configuration = schema, configuration
  end

  def check!
    check_not_nils!
  end

  private

  def check_not_nils!
    [ @schema[:not_nil] ].flatten.compact.each do |key|
      check_not_nil! key
    end
  end

  def check_not_nil!(key)
    value = Configure::Value.new @schema, @configuration, key
    raise Configure::NilValueError, "the value of the key #{key} can't be nil!" if value.get.nil?
  end

end
