require 'rexml/document'

module BulmaFormRails

  # rdoc-image:https://github.com/modgeosys/bulma_form_rails/blob/8fde36bf59e86254cfe9e792f395caba6f60a2a4/doc/images/moderngeosystems_logo.png?raw=true
  # 
  # https://moderngeosystems.com
  # 
  # This Ruby on Rails Helper module allows easy and efficient web form page rendering.
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

  end
  
end
