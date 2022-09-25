require 'rexml/document'

# rdoc-image:images/moderngeosystems_logo.png
module BulmaFormRails

  # rdoc-image:../images/moderngeosystems_logo.png
  # 
  # This Ruby on Rails Helper module allows easy and efficient web form construction with labeled fields of different types.
  # It also supports tabular editable multi-object subforms. 
  module FormPageHelpers
    
    # Render a standard model creation form page.
    # * +name+ - a symbol representing the model name
    # * +model+ - the model object
    # * +models_path+ - the controller URL path for the action that renders the model collection
    def bulma_new_form_page(name, model, models_path)
      render partial: 'bulma_form_rails/new_form_page', locals: {name: name, model: model, models_path: models_path}
    end
  
    # Render a standard model edit form page.
    # * +name+ - a symbol representing the model name
    # * +model+ - the model object
    # * +models_path+ - the controller URL path for the action that renders the model collection
    # * +model_path+ - the controller URL path for the action that renders this individual model
    def bulma_edit_form_page(name, model, models_path, model_path)
      render partial: 'bulma_form_rails/edit_form_page', locals: {name: name, model: model, models_path: models_path, model_path: model_path}
    end
  
    # Render a standard flash messages box.  Automatically included with +bulma_validation_box+ and +bulma_index_header+ output.
    def bulma_message_box
      render partial: 'bulma_form_rails/message_box'
    end

  end
  
end
