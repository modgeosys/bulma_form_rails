require 'rexml/document'

# rdoc-image:images/moderngeosystems_logo.png
module BulmaFormRails

  # rdoc-image:../images/moderngeosystems_logo.png
  # 
  # This Ruby on Rails Helper module allows easy and efficient web form construction with labeled fields of different types.
  # It also supports tabular editable multi-object subforms. 
  module HeaderAndFooterHelpers
    
    # Render the header for a standard index page.  Automatically calls +bulma_message_box+.
    # * +name+ - a symbol representing the model name
    # * +models_path+ - the controller URL path for the action that renders the model collection
    def bulma_index_header(name, models_path)
      render partial: 'bulma_form_rails/index_header', locals: {name: name, models_path: models_path}
    end
  
    # Render a standard model form page footer.
    # * +form+ - the form object
    # * +models_path+ - the controller URL path for the action that renders the model collection
    # * +options+ - a hash of additional options:
    #   * +exclude_submit_button+ - don't include a submit button if true
    # * +block+ - optional ERb to render any additional content for the footer, such as additional buttons
    def bulma_form_footer(form, models_path, options = {}, &block)
      if block_given?
        render layout: 'bulma_form_rails/form_footer', locals: {form: form, url: models_path, options: options}, &block
      else
        render partial: 'bulma_form_rails/form_footer', locals: {form: form, url: models_path, options: options}
      end 
      
    end

  end
  
end