say "Install Bulma Form Rails"
say "Bulma Form Rails requires Stimulus@3.0.1+", :yellow

append_to_file "app/javascript/controllers/index.js", %(\nimport ChildObjectsController from ""#{File.join(Gem.loaded_specs['bulma_form_rails'].full_gem_path, 'lib', 'bulma_form_rails', 'controllers', 'child_objects_controller.js')}"\n)
append_to_file "app/javascript/controllers/index.js", %(application.register("child-objects", ChildObjectsController)\n)
