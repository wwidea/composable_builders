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
          (field_helpers.map { |name| name.to_s } + %w(date_select) - %w(radio_button hidden_field apply_form_for_options! fields_for label)).each do |name|
            create_tagged_field(name)
          end

          create_tagged_field('select', 1)
          create_tagged_field('collection_select', 3)
          create_tagged_field('country_select', 1) if superclass.method_defined?(:country_select)
          create_tagged_field('calendar_date_select', 1) if superclass.method_defined?(:calendar_date_select)
        end
    
        #######
        private
        #######
    
        # create methods to wrap form methods
        # options:
        # - :tail - appended to end of content inside the div
        # - :div_options - passes options into the div tag
        # - :text - change the label text
        # - :required - marks the field as required
        # - :label_id - set the lable id
        def create_tagged_field(method_name, options_position = 0)
          define_method("#{method_name}_with_tags") do |method, *args|
            options = (args[options_position] || {}).reverse_merge!(default_options)
            tail = options.delete(:tail)
            @template.content_tag(:div, options.delete(:div_options)) do
              (String.new.tap do |result|
                result << label(method, label_text(method, options.delete(:text), options.delete(:required)), :id => options.delete(:label_id))
                result << send("#{method_name}_without_tags", method, *args)
                result << tail if tail
              end).html_safe
            end
          end
          alias_method_chain method_name, :tags
        end
      end

      module InstanceMethods
        def submit(value = 'Save Changes', options = {})
          @template.content_tag(:div, @template.submit_tag(value, options))
        end
  
        def cancel(path = {:action => 'index'})
          @template.content_tag(:div, @template.link_to_cancel(path), :class => 'cancel_link')
        end
  
        def radio_select(method, choices, opts = {})
          field_name = opts.delete(:field_name) || format_field_name(method)
          (String.new.tap do |s|
            s << @template.content_tag(:div, @template.content_tag(:label, field_name))
            s << @template.content_tag(:ul, build_radio_buttons(method, choices, opts).html_safe, :class => 'multicheck')
          end).html_safe
        end
        
        def habtm_check_boxes(items, options = {})
          association = options.delete(:association) || items.first.class.name.underscore.pluralize
          @template.content_tag(:div, :class => 'labeled_list') do
            @template.content_tag(:label, (options.delete(:text) || association.titleize)) +
            # ensure array passed to params
            @template.hidden_field_tag(habtm_tag_name(association), nil) +
            @template.content_tag(:ul, :class => 'multicheck') do
              (items.inject('') do |string, item|
                string << @template.content_tag(:li) do
                  @template.check_box_tag(habtm_tag_name(association), item.id, object.send(association).include?(item)) +
                  item.name.to_s
                end
              end).html_safe
            end
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
          String.new.tap do |s|
            choices.each do |name, value|
              s << build_radio_button(method, name, value, (opts[:selected] == name))
            end
            s << build_radio_button(method, 'None') if opts[:include_blank]
          end
        end
        
        def build_radio_button(method, name, value = 0, checked = false)
          @template.content_tag(:li,
            radio_button(method, value, :checked => checked) +
            @template.content_tag(:label, name, :for => "#{@object_name}_#{method}_#{value}")
          )
        end
        
        def habtm_tag_name(association)
          "#{object_name}[#{association.singularize}_ids][]"
        end
      end
    end
  end
end