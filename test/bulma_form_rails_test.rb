ENV['RAILS_ENV'] ||= 'test'
# require_relative "../config/environment"
# require "rails/test_help"
require 'minitest/autorun'

class SampleErrors
  attr_accessor :full_messages

  def initialize(full_messages)
    @full_messages = full_messages
    super()
  end

  def empty?
    false
  end
end

class SampleModel
  attr_accessor :name
  attr_accessor :number
  attr_accessor :errors

  def initialize(name = '', number = 1)
    @name   = name
    @number = number
    @errors = SampleErrors.new(full_messages: ['field1 invalid', 'field2 invalid'])
    super()
  end
end

module BulmaForm
  class Railtie
    @@child_attributes = {sample_model: ['name', 'number']}
  end
end

class Symbol
  def submit(options)
  end
end

class BulmaFormHelperTest < ActionView::TestCase
  def setup
    @name         = 'Sample Name'
    @number       = 2
    @model_symbol = :sample_model
    @model_name   = @model_symbol.to_s
    @model_path   = "/#{@model_name}"
    @models_path  = "/#{@model_name.pluralize}"
    @model        = SampleModel.new(@name, @number)
    @choices      = [['1st', :first], ['2nd', :second]]
    @custom_field_content = 'Custom Field Content'
    @alternate_field_label = 'A different label'
    @additional_class = 'is-danger'
    
    flash[:notice]  = 'Sample notice'
    flash[:warning] = 'Sample warning'
    flash[:error]   = 'Sample error'
    
    @bulma_new_form_page_results = bulma_new_form_page(@model_symbol, @model, @models_path)
    @bulma_edit_form_page_results = bulma_edit_form_page(@model_symbol, @model, @models_path, @model_path) 
    @bulma_form_footer_results = bulma_form_footer(@model_symbol, @models_path)
    @bulma_index_header_results = bulma_index_header(@model_symbol, @models_path)
    @bulma_message_box_results = bulma_message_box
    @bulma_validation_box_results = bulma_validation_box(@model)

    @bulma_child_objects_results = bulma_child_objects([@model], @model_name, @model_symbol, "#{@models_path}/add_child")
    @bulma_child_objects_system_controlled_results = bulma_child_objects([@model], @model_name, @model_symbol, "#{@models_path}/add_child", system_controlled: true)
    
    @bulma_custom_field_results = bulma_custom_field(@model_symbol, :name) {@custom_field_content}
    @bulma_custom_field_label_results = bulma_custom_field(@model_symbol, :name, label: @alternate_field_label) {@custom_field_content}
    
    @bulma_input_text_results = bulma_input(@model_symbol, :name, :text)
    @bulma_input_text_label_results = bulma_input(@model_symbol, :name, :text, label: @alternate_field_label)
    @bulma_input_text_class_results = bulma_input(@model_symbol, :name, :text, class: @additional_class)
    @bulma_input_number_results = bulma_input(@model_symbol, :number, :number)
    @bulma_input_number_options_results = bulma_input(@model_symbol, :number, :number, min: 0, max: 0)
    
    @bulma_text_area_results = bulma_text_area(@model_symbol, :name, rows: 5, cols: 80)
    @bulma_text_area_class_results = bulma_text_area(@model_symbol, :name, rows: 5, cols: 80, class: @additional_class)
    @bulma_text_area_label_results = bulma_text_area(@model_symbol, :name, label: @alternate_field_label)
    
    @bulma_check_box_results = bulma_check_box(@model_symbol, :name)
    @bulma_check_box_class_results = bulma_check_box(@model_symbol, :name, class: @additional_class)
    @bulma_check_box_label_results = bulma_check_box(@model_symbol, :name, label: @alternate_field_label)
    
    @bulma_radio_group_results = bulma_radio_group(@model_symbol, :name, @choices)
    @bulma_radio_group_class_results = bulma_radio_group(@model_symbol, :name, @choices, class: @additional_class)
    @bulma_radio_group_label_results = bulma_radio_group(@model_symbol, :name, @choices, label: @alternate_field_label)
    
    @bulma_select_results = bulma_select(@model_symbol, :name, @choices)
    @bulma_select_class_results = bulma_select(@model_symbol, :name, @choices, class: @additional_class)
    @bulma_select_label_results = bulma_select(@model_symbol, :name, @choices, label: @alternate_field_label)
    
    @bulma_datetime_select_results = bulma_datetime_select(@model_symbol, :name)
    @bulma_datetime_select_class_results = bulma_datetime_select(@model_symbol, :name, class: @additional_class)
    @bulma_datetime_select_label_results = bulma_datetime_select(@model_symbol, :name, label: @alternate_field_label)
    
    @bulma_time_select_results = bulma_time_select(@model_symbol, :name)
    @bulma_time_select_class_results = bulma_time_select(@model_symbol, :name, class: @additional_class)
    @bulma_time_select_label_results = bulma_time_select(@model_symbol, :name, label: @alternate_field_label)
  end

  def teardown
  end

  test "#bulma_new_form_page displays a model-specific page title" do
    assert_match /<h1 class="title">Create new #{@model_name.humanize.capitalize}<\/h1>/, @bulma_new_form_page_results
  end

  test "#bulma_edit_form_page displays a model-specific page title" do
    assert_match /<h1 class="title">Edit #{@model_name.humanize.capitalize}<\/h1>/, @bulma_edit_form_page_results
  end
  
  test "#bulma_index_header displays the readable plural model name" do
    assert_match /<h1 class="title">#{@model_name.humanize.pluralize}<\/h1>/, @bulma_index_header_results
  end

  test "#bulma_index_header displays a button to navigate to the model's path" do
    # skip 'Not implemented'
    assert_match /<a class="button is-primary" href="#{@models_path}">New<\/a>/, @bulma_index_header_results
  end

  test "#bulma_message_box includes notices" do
    assert_match /<div class="message is-primary">\n\s*<div class="message-header">\n\s*<p>Notice<\/p>\n.*<\/div>\n.*<div class="message-body">\n\s*<p>#{flash[:notice]}<\/p>\n\s*<\/div>\n\s*<\/div>/, @bulma_message_box_results
  end

  test "#bulma_message_box includes warnings" do
    assert_match /<div class="message is-warning">\n\s*<div class="message-header">\n\s*<p>Warning<\/p>\n.*<\/div>\n.*<div class="message-body">\n\s*<p>#{flash[:warning]}<\/p>\n\s*<\/div>\n\s*<\/div>/, @bulma_message_box_results
  end

  test "#bulma_message_box includes errors" do
    assert_match /<div class="message is-danger">\n\s*<div class="message-header">\n\s*<p>Error<\/p>\n.*<\/div>\n.*<div class="message-body">\n\s*<p>#{flash[:error]}<\/p>\n\s*<\/div>\n\s*<\/div>/, @bulma_message_box_results
  end
  
  test "#bulma_validation_box displays all error messages" do
    @model.errors.full_messages.each { |full_message| assert_match /#{full_message}/, @bulma_validation_box_results }
  end
  
  test "#bulma_form_footer displays a Never Mind button" do
    assert_match /<a class="button is-warning" href="\/#{@model_name.pluralize}">Never Mind<\/a>/, @bulma_form_footer_results
  end

  def check_default_field_label(test_results)
    assert_match /<label class="label" for="#{@model_name}_name">Name<\/label>/, test_results
  end

  def check_specified_field_label(test_results)
    assert_match /<label class="label" for="#{@model_name}_name">#{@alternate_field_label}<\/label>/, test_results
  end

  test "#bulma_child_objects displays a default label" do
    assert_match /<label class="label">#{@model_name.humanize.pluralize.titleize}<\/label>/, @bulma_child_objects_results
  end

  test "#bulma_child_objects displays a subform" do
    assert_match /<tbody id="#{@model_name}-table" data-controller="child-objects" data-child-objects-target="table" data-child-objects-url-value="\/#{@model_name.pluralize}\/add_child" data-child-objects-name-value="#{@model_name}" data-child-objects-attributes-key-value="#{@model_name}">/, @bulma_child_objects_results
  end
  
  test "#bulma_child_objects displays a model field" do
    assert_match /<input type="text" name="#{@model_name.pluralize}\[0\]\[name\]" id="#{@model_name.pluralize}_0_name" value="#{@name}" size="10" class="#{@model_name.pluralize}_name input is-small" data-sample-models-container="" data-sample-models-container-class="" data-sample-models-form-id="" data-action="change-&gt;sample-models#updateTotals" \/>/, @bulma_child_objects_results
  end
  
  test "#bulma_child_objects displays row add and delete buttons" do
    assert_match /<button name="button" type="button" class="button is-small is-danger" data-action="click-&gt;child-objects#deleteRow">delete<\/button>/, @bulma_child_objects_results
    assert_match /<button name="button" type="button" class="button is-small is-primary" data-action="click-&gt;child-objects#addRow">add another<\/button>/, @bulma_child_objects_results
  end
  
  test "#bulma_child_objects does not display row add or delete buttons if system_controlled is set to true" do
    assert_no_match /<button name="button" type="button" class="button is-small is-danger" data-action="click-&gt;child-objects#deleteRow">delete<\/button>/, @bulma_child_objects_system_controlled_results
    assert_no_match /<button name="button" type="button" class="button is-small is-primary" data-action="click-&gt;child-objects#addRow">add another<\/button>/, @bulma_child_objects_system_controlled_results
  end
  
  test "#bulma_custom_field displays a default label" do
    check_default_field_label @bulma_custom_field_results
  end

  test "#bulma_child_objects displays a specified label" do
    check_specified_field_label @bulma_custom_field_label_results
  end
  
  test "#bulma_custom_field displays the specified content" do
    assert_match /#{@custom_field_content}/, @bulma_custom_field_results
  end

  test "#bulma_input displays a default label" do
    check_default_field_label @bulma_input_text_results
  end

  test "#bulma_input displays a specified label" do
    check_specified_field_label @bulma_input_text_label_results
  end

  test "#bulma_input :text displays a text field" do
    assert_match /<input class="input" type="text" name="#{@model_name}\[name\]" id="#{@model_name}_name" \/>/, @bulma_input_text_results
  end
  
  test "#bulma_input displays a field with an additional CSS class" do
    assert_match /class="input #{@additional_class}"/, @bulma_input_text_class_results
  end
  
  test "#bulma_input :number displays a non-text field type" do
    assert_match /<input class="input" type="number" name="#{@model_name}\[number\]" id="#{@model_name}_number" \/>/, @bulma_input_number_results
  end
  
  test "#bulma_input includes additional input tag attributes" do
    assert_match /<input min="0" max="0" class="input" type="number" name="#{@model_name}\[number\]" id="#{@model_name}_number" \/>/, @bulma_input_number_options_results
  end
  
  test "#bulma_text_area displays a default label" do
    check_default_field_label @bulma_text_area_results
  end
  
  test "#bulma_text_area displays a specified label" do
    check_specified_field_label @bulma_text_area_label_results
  end

  test "#bulma_text_area displays a text area field" do
    assert_match /<textarea rows="5" cols="80" class="textarea" name="#{@model_name}\[name\]" id="#{@model_name}_name">\n\s*<\/textarea>/, @bulma_text_area_results
  end

  test "#bulma_text_area displays a field with an additional CSS class" do
    assert_match /<textarea rows="5" cols="80" class="textarea #{@additional_class}" name="#{@model_name}\[name\]" id="#{@model_name}_name">\n\s*<\/textarea>/, @bulma_text_area_class_results
  end
  
  test "#bulma_check_box displays a default label" do
    check_default_field_label @bulma_check_box_results
  end
  
  test "#bulma_check_box displays a specified label" do
    check_specified_field_label @bulma_check_box_label_results
  end
  
  test "#bulma_check_box displays a checkbox field" do
    assert_match /<input class="checkbox" type="checkbox" value="1" name="#{@model_name}\[name\]" id="#{@model_name}_name" \/>/, @bulma_check_box_results
  end

  test "#bulma_check_box displays a field with an additional CSS class" do
    assert_match /<input class="checkbox #{@additional_class}" type="checkbox" value="1" name="#{@model_name}\[name\]" id="#{@model_name}_name" \/>/, @bulma_check_box_class_results
  end
  
  test "#bulma_radio_group displays a default label" do
    check_default_field_label @bulma_radio_group_results
  end
  
  test "#bulma_radio_group displays a specified label" do
    check_specified_field_label @bulma_radio_group_label_results
  end
  
  test "#bulma_radio_group displays all radio group options" do
    @choices.each {|choice| assert_match /<input class="radio" type="radio" value="#{choice[0]}" name="#{@model_name}\[name\]" id="#{@model_name}_name_#{choice[0]}" \/>\n\s*<label class="radio" for="#{@model_name}_#{choice[1]}">#{choice[1].to_s.humanize}<\/label>/, @bulma_radio_group_results}
  end
  
  test "#bulma_radio_group displays all options with an additional CSS class" do
    @choices.each {|choice| assert_match /<input class="radio #{@additional_class}" type="radio" value="#{choice[0]}" name="#{@model_name}\[name\]" id="#{@model_name}_name_#{choice[0]}" \/>\n\s*<label class="radio #{@additional_class}" for="#{@model_name}_#{choice[1]}">#{choice[1].to_s.humanize}<\/label>/, @bulma_radio_group_class_results}
  end
  
  test "#bulma_select displays a default label" do
    check_default_field_label @bulma_select_results
  end
  
  test "#bulma_select displays a specified label" do
    check_specified_field_label @bulma_select_label_results
  end
  
  test "#bulma_select displays all selection options" do
    @choices.each {|choice| assert_match /<option value="#{choice[1]}">#{choice[0]}<\/option>/, @bulma_select_results}
  end

  test "#bulma_select displays a field with an additional CSS class" do
    assert_match /<div class="select is-fullwidth #{@additional_class}">/, @bulma_select_class_results
  end

  test "#bulma_datetime_select displays a default label" do
    check_default_field_label @bulma_datetime_select_results
  end
  
  test "#bulma_datetime_select displays a specified label" do
    check_specified_field_label @bulma_datetime_select_label_results
  end
  
  test "#bulma_datetime_select displays a date and time select tag" do
    assert_match /<select id='#{@model_name}_.*_1i' name='#{@model_name}\[.*\(1i\)\]'>/, @bulma_datetime_select_results
  end

  test "#bulma_datetime_select displays a field with an additional CSS class" do
    assert_match /<div class="select is-fullwidth #{@additional_class}">/, @bulma_datetime_select_class_results
  end
  
  test "#bulma_time_select displays a default label" do
    check_default_field_label @bulma_time_select_results
  end
  
  test "#bulma_time_select displays a specified label" do
    check_specified_field_label @bulma_time_select_label_results
  end
  
  test "#bulma_time_select displays a time select tag" do
    assert_match /<select id='#{@model_name}_.*_4i' name='#{@model_name}\[.*\(4i\)\]'>/, @bulma_time_select_results
  end

  test "#bulma_time_select displays a field with an additional CSS class" do
    assert_match /<div class="select is-fullwidth #{@additional_class}">/, @bulma_time_select_class_results
  end
end
