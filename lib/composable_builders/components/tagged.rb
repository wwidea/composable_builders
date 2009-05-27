module ComposableBuilders
  module Components
    module Tagged
      def self.included( base )
        base.extend(ClassMethods)
        base.class_eval do
          include InstanceMethods
          self.define_methods(superclass.field_helpers)
        end
      end
  
      module ClassMethods
        def define_methods(field_helpers)
          (field_helpers + %w(date_select) - %w(radio_button hidden_field apply_form_for_options! fields_for label)).each do |name|
            create_tagged_field(name)
          end

          create_tagged_field('select', 1)
          create_tagged_field('collection_select', 3)
          create_tagged_field('country_select', 1) if superclass.method_defined?(:country_select)
        end
    
        #######
        private
        #######
    
        def create_tagged_field(method_name, options_position = 0)
          define_method("#{method_name}_with_tags") do |method, *args|
            options = (args[options_position] || {}).reverse_merge!(default_options)
            @template.content_tag(:div) do
              returning String.new do |result|
                result << label(method, label_text(method, options.delete(:text), options.delete(:required)), :id => options.delete(:label_id))
                result << send("#{method_name}_without_tags", method, *args)
              end
            end
          end
          alias_method_chain method_name, :tags
        end
      end

      module InstanceMethods
        def submit(*args)
          # options = args.last.is_a?(Hash) ? args.pop : {}
          # options.reverse_merge!(:class => 'submit_button')
          # args << options
          @template.content_tag(:div, @template.submit_tag(*args))
        end
  
        def cancel(path = {:action => 'index'})
          @template.content_tag(:div, @template.link_to_cancel(path))
        end
  
        def radio_select(method, choices, opts = {})
          field_name = opts.delete(:field_name) || format_field_name(method)
          returning String.new do |s|
            s << @template.content_tag(:div, @template.content_tag(:label, field_name))
            s << @template.content_tag(:ul, build_radio_buttons(method, choices, opts), :class => 'multicheck')
          end
        end
  
        #######
        private
        #######
        
        def label_text(method, text, required = nil)
          (text || method.to_s.humanize) + (required ? ('&nbsp;' + @template.image_tag('icon_required.gif')) : '')
        end
        
        def format_field_name(name)
          name = name.to_s
          name.slice!(0, name.index('.') + 1) if name.index('.')
          name.titleize
        end
        
        def build_radio_buttons(method, choices, opts)
          returning String.new do |s|
            choices.each do |name, value|
              s << build_radio_button(method, name, value)
            end
            s << build_radio_button(method, 'None') if opts[:include_blank]
          end
        end
        
        def build_radio_button(method, name, value = 0)
          @template.content_tag(:li,
            radio_button(method, value) +
            @template.content_tag(:label, name, :for => "#{@object_name}_#{method}_#{value}")
          )
        end
      end
    end
  end
end