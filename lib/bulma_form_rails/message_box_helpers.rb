require 'rexml/document'

module BulmaFormRails

  # rdoc-image:https://github.com/modgeosys/bulma_form_rails/blob/e5b42592ca04a9579e97fb774f9f22e3a26d380c/doc/images/modgeosys_logo.jpg?raw=true
  # 
  # https://kevinweller.name
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
