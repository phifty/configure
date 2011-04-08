
module Configure

  autoload :Injector, File.join(File.dirname(__FILE__), "configure", "injector")
  autoload :Sandbox, File.join(File.dirname(__FILE__), "configure", "sandbox")
  autoload :Schema, File.join(File.dirname(__FILE__), "configure", "schema")

  # This error is thrown, if a key can't be set or get.
  class InvalidKeyError < StandardError; end

  # This error is thrown, if a value is nil that shouldn't be nil.
  class NilValueError < StandardError; end

  def self.process(schema = { }, &block)
    process_configuration schema, &block
  end

  def self.process_configuration(schema = { }, &block)
    injector = Injector.new schema
    sandbox = Sandbox.new injector
    sandbox.instance_eval &block
    injector.configuration
  end

end
