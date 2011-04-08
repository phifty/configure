
module Configure

  autoload :Checker, File.join(File.dirname(__FILE__), "configure", "checker")
  autoload :Injector, File.join(File.dirname(__FILE__), "configure", "injector")
  autoload :Sandbox, File.join(File.dirname(__FILE__), "configure", "sandbox")
  autoload :Schema, File.join(File.dirname(__FILE__), "configure", "schema")
  autoload :Value, File.join(File.dirname(__FILE__), "configure", "value")

  # This error is thrown, if a key can't be set or get.
  class InvalidKeyError < StandardError; end

  # This error is thrown, if a value is nil that shouldn't be nil.
  class NilValueError < StandardError; end

  def self.process(schema = nil, &block)
    schema ||= Schema.build { }
    process_configuration schema, &block
  end

  def self.process_configuration(schema = { }, &block)
    injector = Injector.new schema
    Sandbox.new(injector).instance_eval &block
    configuration = injector.configuration
    Checker.new(schema, configuration).check!
    configuration
  end

end
