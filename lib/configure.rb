
module Configure

  autoload :Injector, File.join(File.dirname(__FILE__), "configure", "injector")
  autoload :Sandbox, File.join(File.dirname(__FILE__), "configure", "sandbox")

  def self.process(&block)
    process_configuration Hash, &block
  end

  def self.process_configuration(configuration_class, &block)
    injector = Injector.new configuration_class
    sandbox = Sandbox.new injector
    sandbox.instance_eval &block
    injector.configuration
  end

end
