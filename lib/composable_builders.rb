# ComposableBuilders
require 'builders/composable_builder'
require 'composable_builders/components/global'
require 'composable_builders/components/deformable'
require 'composable_builders/components/printable'
require 'composable_builders/components/tagged'

def ComposableBuilder(options = {})
  ComposableBuilder.create(options)
end

module ActionView
  module Helpers
    def tagged_builder
      ComposableBuilder(:tagged => true)
    end
    
    def printable_builder
      ComposableBuilder(:printable => true)
    end
    
    def tagged_printable_builder
      ComposableBuilder(:tagged => true, :printable => true)
    end
    
    def deformable_builder
      ComposableBuilder(:deformable => true)
    end
    
    def tagged_deformable_builder
      ComposableBuilder(:tagged => true, :deformable => true)
    end
  end
end