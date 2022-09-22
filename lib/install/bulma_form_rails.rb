say "Install Bulma Form Rails"
say "Bulma Form Rails requires Stimulus@3.0.1+", :yellow

append_to_file "app/javascript/controllers/index.js", %(\nimport ChildObjectsController from "./child_objects_controller.js"\n)
append_to_file "app/javascript/controllers/index.js", %(application.register("child-objects", ChildObjectsController)\n)
