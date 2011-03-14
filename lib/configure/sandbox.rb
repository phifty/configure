
# The sandbox can be used to catch method calls and delegates them the to passed injector.
class Configure::Sandbox

   def initialize(injector)
     @injector = injector
   end

   def method_missing(method_name, *arguments, &block)
     if block_given?
       @injector.put_block method_name, &block
     else
       @injector.put_arguments method_name, arguments
     end
   end

end
