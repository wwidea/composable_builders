module ComposableBuilders
  module Components
    module Printable
      TEMPLATE_FORMAT = :pdf
  
      def self.included( base )
        base.extend(ClassMethods)
        base.class_eval do
          include InstanceMethods
          self.define_methods
        end
      end
  
      module ClassMethods
        def define_methods
          %w(date_select select text_field).each do |method|
            define_method(method.to_sym) do |*args|
              if @template.formats.include?(TEMPLATE_FORMAT)
                send("#{method}_for_pdf", *args)
              else
                super(*args)
              end
            end
          end
        end
      end
  
      module InstanceMethods
        def select_for_pdf(method, choices, options = {}, html_options = {})
          return blank_line if options[:blank_line]
          @template.content_tag(:ul, (choices.inject(String.new) { |string,choice| string += @template.content_tag(:li, Array(choice).first) }).html_safe, :class =>'list')
        end

        def date_select_for_pdf(*args)
          blank_line
        end

        def text_field_for_pdf(*args)
          blank_line
        end

        #######
        private
        #######

        def blank_line
          @template.content_tag(:span, ('_' * 40), :class => 'line')
        end
      end
    end
  end
end