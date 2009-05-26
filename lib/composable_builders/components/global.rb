module ComposableBuilders
  module Components
    module Global
      def self.included( base )
        base.extend(ClassMethods)
        base.class_eval do
          include InstanceMethods
        end
      end
      
      module ClassMethods
        
      end
      
      module InstanceMethods
    
        def default_options
          # rails uses an instance variable named default_options
          @composable_builder_default_options ||= {}
        end
        
        def set_defaults(options = {})
          # rails uses an instance variable named default_options
          @composable_builder_default_options = options
        end
    
      end
    end
  end
end
