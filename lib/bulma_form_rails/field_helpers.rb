require 'rexml/document'

# rdoc-image:https://github.com/modgeosys/bulma_form_rails/blob/371b651b4cf38336f85378467f15b98b5367049e/doc/images/modgeosys_logo.jpg?raw=true
# 
# https://kevinweller.name
module BulmaFormRails

  # rdoc-image:https://github.com/modgeosys/bulma_form_rails/blob/371b651b4cf38336f85378467f15b98b5367049e/doc/images/modgeosys_logo.jpg?raw=true
  # 
  # https://kevinweller.name
  # 
  # This Ruby on Rails Helper module allows easy and efficient web form construction with labeled fields of different types.
  module FieldHelpers
    
    # Render a labeled field with custom content.
    # * +form_or_object+ - the form or object
    # * +field_name+ - a symbol representing the name of the field as a whole, regardless of how many tags are in the specified ERb block
    # * +options+ - a hash of additional options:
    #   * +label+ - custom field label text
    # * +block+ - ERb to render the field value content
    def bulma_custom_field(form_or_object, field_name, options = {}, &block)
      # Prepare parameters.
      raise ArgumentError.new('No block given for custom field') if !block_given?
      render_parameters = prepare_common_parameters(field_name, form_or_object, options)
      render_parameters.merge!(additional_field_label_classes: 'is-normal') unless options[:contains_check_box_or_radio_group]
  
      # Render the labeled field.
      render layout: 'bulma_form_rails/field', locals: render_parameters, &block
    end
  
    VALID_INPUT_TYPES = %i[color date datetime_local email file hidden month number password phone telephone text time url]
    
    # Render a labeled input field.
    # Mandatory parameters:
    # * +form_or_object+ - the form or object
    # * +field_name+ - a symbol representing the name of the field
    # * +type+ - +:color+, +:date+, +:datetime_local+, +:email+, +:file+, +:hidden+, +:month+, +:number+, +:password+, +:phone+, +:telephone+, +:text+, +:time+, or +:url+ with optional +_field+ suffix
    # * +options+ - a hash of additional options:
    #   * +class+ - additional input classes other than +input+
    #   * +label+ - custom field label text
    def bulma_input(form_or_object, field_name, type = :text, options = {})
      # Convert type to form method.
      type = type.to_s
      type.delete!('_field') if type.end_with?('_field')
      raise ArgumentError.new("Invalid input type #{type.inspect}") unless VALID_INPUT_TYPES.any?(type.intern)
      method = "#{type}_field".intern
  
      # Prepare parameters.
      prepare_value_class!(options, base_class: 'input')
      render_parameters = prepare_common_parameters(field_name, form_or_object, options)
      additional_render_parameters = %i[date_field datetime_local_field month_field time_field].any?(method) ? {additional_field_classes: 'is-narrow'} : {}
  
      # Render the labeled field.
      render layout: 'bulma_form_rails/field', locals: render_parameters.merge(additional_field_label_classes: 'is-normal') do
        render partial: 'bulma_form_rails/value', locals: render_parameters.merge(method: method).merge(additional_render_parameters)
      end 
    end
    
    # Render a labeled text area field.
    # * +form_or_object+ - the form or object
    # * +field_name+ - a symbol representing the name of the field
    # * +options+ - a hash of additional options:
    #   * +class+ - additional textarea classes other than +textarea+
    #   * +label+ - custom field label text
    #   * +rows+ - number of text rows to be visible
    #   * +cols+ - number of text columns to be visible
    def bulma_text_area(form_or_object, field_name, options = {})
      # Prepare parameters.
      prepare_value_class!(options, base_class: 'textarea')
      render_parameters = prepare_common_parameters(field_name, form_or_object, options)
  
      # Render the labeled field.
      render layout: 'bulma_form_rails/field', locals: render_parameters.merge(additional_field_label_classes: 'is-normal') do
        render partial: 'bulma_form_rails/value', locals: render_parameters.merge(method: :text_area)
      end
    end
    
    # Render a labeled checkbox field.
    # * +form_or_object+ - the form or object
    # * +field_name+ - a symbol representing the name of the field
    # * +options+ - a hash of additional options:
    #   * +class+ - additional checkbox classes other than +checkbox+
    #   * +label+ - custom field label text
    def bulma_check_box(form_or_object, field_name, options = {})
      # Prepare parameters.
      prepare_value_class!(options, base_class: 'checkbox')
      render_parameters = prepare_common_parameters(field_name, form_or_object, options)
  
      # Render the labeled field.
      render layout: 'bulma_form_rails/field', locals: render_parameters do
        render partial: 'bulma_form_rails/value', locals: render_parameters.merge(method: :check_box, additional_field_classes: 'is-narrow')
      end
    end
  
    # Render a labeled radio group field.
    # * +form_or_object+ - the form or object
    # * +field_name+ - a symbol representing the name of the field as a whole, regardless of how many radio buttons are generated by +choices+
    # * +choices+ - an array of radio button choice options
    # * +options+ - an array of additional options
    #   * +class+ - additional radio classes other than +radio+
    #   * +label+ - custom field label text
    def bulma_radio_group(form_or_object, field_name, choices, options = {})
      # Prepare parameters.
      prepare_value_class!(options, base_class: 'radio')
      render_parameters = prepare_common_parameters(field_name, form_or_object, options)
  
      # Render the labeled field.
      render layout: 'bulma_form_rails/field', locals: render_parameters do
        render partial: 'bulma_form_rails/radio_group', locals: render_parameters.merge(choices: choices)
      end
    end
  
    # Render a labeled selection field.
    # * +form_or_object+ - the form or object
    # * +field_name+ - a symbol representing the name of the field
    # * +choices+ - an array of select choice options
    # * +options+ - a hash of additional options
    #   * +class+ - additional select classes other than +select+
    #   * +label+ - custom field label text
    # * +html_options+ - a hash of additional options:
    def bulma_select(form_or_object, field_name, choices, options = {}, html_options = {})
      # Prepare parameters.
      prepare_value_class!(options, base_class: 'select is-fullwidth')
      render_parameters = prepare_common_parameters(field_name, form_or_object, options)
  
      # Render the labeled field.
      render layout: 'bulma_form_rails/field', locals: render_parameters.merge(additional_field_label_classes: 'is-normal') do
        render partial: 'bulma_form_rails/select', locals: render_parameters.merge(choices: choices, html_options: html_options)
      end
    end
  
    # Render a labeled date+time selection field.
    # * +form_or_object+ - the form or object
    # * +field_name+ - a symbol representing the name of the field
    # * +options+ - a hash of additional options
    # * +html_options+ - a hash of additional options:
    #   * +class+ - additional select classes other than +select+
    #   * +label+ - custom field label text
    def bulma_datetime_select(form_or_object, field_name, options = {}, html_options = {})
      # Prepare parameters.
      prepare_value_class!(options, base_class: 'select is-fullwidth')
      render_parameters = prepare_common_parameters(field_name, form_or_object, options)
  
      # Render the labeled field.
      render layout: 'bulma_form_rails/field', locals: render_parameters.merge(additional_field_label_classes: 'is-normal') do
        render partial: 'bulma_form_rails/datetime_select', locals: render_parameters.merge(html_options: html_options)
      end
    end
  
    # Render a labeled time selection field.
    # * +form_or_object+ - the form or object
    # * +field_name+ - a symbol representing the name of the field
    # * +options+ - a hash of additional options
    # * +html_options+ - a hash of additional options:
    #   * +class+ - additional select classes other than +select+
    #   * +label+ - custom field label text
    def bulma_time_select(form_or_object, field_name, options = {}, html_options = {})
      # Prepare parameters.
      prepare_value_class!(options, base_class: 'select is-fullwidth')
      render_parameters = prepare_common_parameters(field_name, form_or_object, options)
  
      # Render the labeled field.
      render layout: 'bulma_form_rails/field', locals: render_parameters.merge(additional_field_label_classes: 'is-normal') do
        render partial: 'bulma_form_rails/time_select', locals: render_parameters.merge(html_options: html_options)
      end
    end
  
    private
  
    # Render time selection tags modified for bulma compatibility.
    def bulma_datetime_select_tags(html)
      # Parse the template-generated HTML, wrapping it in a div to ensure a single root element.
      source = if html =~ /\A\s*<div/
                 html
               else
                 "<div>#{html}</div>"
               end
      document = REXML::Document.new(source)
      root = document.root
      
      # Remove all non-functional text nodes
      root.delete_if {|child| child.instance_of?(REXML::Text)}
      
      # Subsume all select elements under their own bulma span tags.
      root.each_element do |element|
        if element.name == "select"
          # Create the span.
          span = REXML::Element.new('span')
          span.add_attribute('class', 'control')
          span.add_attribute('style', 'display: inline-block')
          
          # Reparent the select.
          root.add_element(span)
          span.add_element(element)
        end
      end
      
      # Emit the modified HTML.
      output = ""
      document.write(output)
      output
    end
    
    # Render any form element, regardless of whether a form builder or object name is provided.
    def bulma_form_or_object_component(form_or_object, method, *params)
      if form_or_object.kind_of?(ActionView::Helpers::FormBuilder)
        form_or_object.public_send(method, *params)
      else
        self.public_send(method, *([form_or_object] + params))
      end
    end
    
    def prepare_common_parameters(field_name, form_or_object, options)
      { form_or_object: form_or_object, field_name: field_name, label_parameters: prepare_label_parameters(field_name, options), options: options }
    end
  
    # Grab and purge the textual field label from options if specified.
    def prepare_label_parameters(field_name, options)
      label_parameters = [field_name]
      field_label      = options[:label]
      if field_label
        label_parameters << field_label
        options.delete(:label)
      end
      label_parameters << { class: 'label' }
    end
  
    # Grab and purge value CSS classes from options if specified.
    def prepare_value_class!(options, base_class: String)
      additional_classes = options[:class]
      if additional_classes
        additional_classes = " #{additional_classes}"
        options.delete(:class)
      else
        additional_classes = ''
      end
      options[:class] = base_class + additional_classes
    end

  end
  
end
