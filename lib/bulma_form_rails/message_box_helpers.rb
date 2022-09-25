require 'rexml/document'

module BulmaFormRails

  # rdoc-image:https://github.com/modgeosys/bulma_form_rails/blob/8fde36bf59e86254cfe9e792f395caba6f60a2a4/doc/images/moderngeosystems_logo.png?raw=true
  # 
  # https://moderngeosystems.com
  # 
  # This Ruby on Rails Helper module allows easy and efficient flash and validation error box rendering.
  module MessageBoxHelpers
    
    # Render a standard flash messages box.  Automatically included with +bulma_validation_box+ and +bulma_index_header+ output.
    def bulma_message_box
      render partial: 'bulma_form_rails/message_box'
    end
  
    # Render a standard model validation messages box.  Automatically calls +bulma_message_box+.
    # * +model+ - the model object
    def bulma_validation_box(model)
      render partial: 'bulma_form_rails/validation_box', locals: {model: model}
    end

  end
  
end
