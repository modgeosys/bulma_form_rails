say "Install Bulma Form Rails"
say "Bulma Form Rails requires Stimulus@3.0.1+", :yellow

copy_file File.join(Gem.loaded_specs['bulma_form_rails'].full_gem_path, 'lib', 'bulma_form_rails', 'javascript', 'controllers', 'child_objects_controller.js'), File.join('app', 'javascript', 'controllers', 'child_objects_controller.js') 
append_to_file "app/javascript/controllers/index.js", %(\nimport ChildObjectsController from "./child_objects_controller.js"\n)
append_to_file "app/javascript/controllers/index.js", %(application.register("child-objects", ChildObjectsController)\n)
