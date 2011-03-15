
module Configure::Schema

  SCHEMA = {

  }.freeze

  def self.build(&block)
    Configure.process SCHEMA, &block
  end

end
