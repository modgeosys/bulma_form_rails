say "Install Bulma Form Rails"
say "Bulma Form Rails requires Stimulus@3.0.1+", :yellow

# Register Stimulus controller
append_to_file File.join('app', 'javascript', 'controllers', 'index.js'), %(\nimport ChildObjectsController from "./child_objects_controller.js"\n)
append_to_file File.join('app', 'javascript', 'controllers', 'index.js'), %(application.register("child-objects", ChildObjectsController)\n)

# Configure Pagy
copy_file File.join(Gem.loaded_specs['bulma_form_rails'].full_gem_path, 'lib', 'templates', 'config', 'initializers', 'pagy.rb'), File.join('config', 'initializers', 'pagy.rb')

# Configure RBS
copy_file File.join(Gem.loaded_specs['bulma_form_rails'].full_gem_path, 'sig', 'bulma_form_helper.rbs'), File.join('sig', 'bulma_form_helper.rbs')
