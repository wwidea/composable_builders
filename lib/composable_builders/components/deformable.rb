module ComposableBuilders
  module Components
    module Deformable
      def self.included( base )
        base.extend(ClassMethods)
        base.class_eval do
          include InstanceMethods
          self.define_methods
        end
      end
      
      module ClassMethods
        def define_methods
          %w(date_select select text_field text_area).each do |method_name|
            define_method(method_name.to_sym) do |method, *args|
              display_value_for_method(method)
            end
          end
        end
      end
      
      module InstanceMethods
        def label(method_name, text = nil, options = {})
          @template.content_tag(:div, (text ? text : method_name.to_s.humanize), :class => 'deformed_field_label')
        end
        
        #######
        private
        #######
        
        def display_value_for_method(method)
          @template.content_tag(:div, format_for_display(get_value_for_method(method)), :class => 'deformed_field_value')
        end
        
        def get_value_for_method(method)
          object.send(method.to_s.gsub(/_id$/, ''))
        end
        
        def format_for_display(value)
          result = case value
            when Date, Time
              value.strftime("%m/%d/%y")
            when TrueClass
              'Yes'
            when FalseClass
              'No'
            when String
              value[/\n/] ? @template.simple_format(value) : value
            else value.respond_to?(:name) ? value.name : value.to_s
          end
          result.blank? ? '&nbsp;' : result
        end
      end
    end
  end
end
