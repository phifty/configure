
module Configure

  autoload :Injector, File.join(File.dirname(__FILE__), "configure", "injector")
  autoload :Sandbox, File.join(File.dirname(__FILE__), "configure", "sandbox")

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
