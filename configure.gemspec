# encoding: utf-8

Gem::Specification.new do |specification|
  specification.name              = "configure"
  specification.version           = "0.1.0"
  specification.date              = "2011-03-14"

  specification.authors           = [ "Philipp Brüll" ]
  specification.email             = "b.phifty@gmail.com"
  specification.homepage          = "http://github.com/phifty/configure"
  specification.rubyforge_project = "configure"

  specification.summary           = "Configure offers an easy way for configure your application using a DSL."
  specification.description       = "It provides a single-method interface that receives a block and returns well-structured configuration values."

  specification.has_rdoc          = true
  specification.files             = [ "README.rdoc", "LICENSE", "Rakefile" ] + Dir["lib/**/*"] + Dir["spec/**/*"]
  specification.extra_rdoc_files  = [ "README.rdoc" ]
  specification.require_path      = "lib"

  specification.test_files        = Dir["spec/**/*_spec.rb"]

  specification.add_development_dependency "rspec", ">= 2"
  specification.add_development_dependency "reek", ">= 1.2"
end
