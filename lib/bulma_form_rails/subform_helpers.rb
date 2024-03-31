require 'rexml/document'

module BulmaFormRails

  # rdoc-image:https://github.com/modgeosys/bulma_form_rails/blob/371b651b4cf38336f85378467f15b98b5367049e/doc/images/modgeosys_logo.jpg?raw=true
  # 
  # https://kevinweller.name
  # 
  # This Ruby on Rails Helper module supports tabular editable multi-object subforms. 
  module SubformHelpers
    
    # Renders a child objects collection management UI subform, including row addition and deletion buttons by default.
    # * +collection+ - an array of serializable objects
    # * +name+ - the lower-case singular name of the object for display purposes
    # * +attributes_key+ - a symbolic key into the attribute reference hash retrievable via the <tt>lookup_attributes(key)</tt> method defined on the controller as a +helper_method+, eg +:object+ for:
    #                      {object: ["attribute_1", "attribute_2"]}
    # * +add_child_path+ - the controller URL path for the action to add a child object to the collection
    # * +options+ - a hash of additional options to pass to the partials
    #   * +system_controlled+ - +true+ if you want no row add or delete buttons, +false+ or unspecified if you do want add and delete buttons
    #   * +total_columns+ - an array of integers representing column numbers requiring arithmetic totals at the bottom of the subform, eg:
    #                       [3, 4]
    #   * +container+ - a string representing an array index expression for a row if not a single index, eg:
    #                   "[related_reservations][#{related_reservation_counter}]"
    # To use this helper method, you will first need to do the following:
    # 1. Call <tt>bulma_child_forms</tt> from the specific controller (but outside any existing method definitions) for your view, passing in a hash of the object collections to be managed along with their attributes, for example, <tt>{object1: %w[attr1 attr2], object2: %w[attr3 attr4]}</tt>.
    # 2. Add a route to the <tt>add_child</tt> action for the same controller, for example, <tt>put 'users/add_child', to: 'users#add_child'</tt>. 
    def bulma_child_objects(collection, name, attributes_key, add_child_path, options = {})
      render partial: 'bulma_form_rails/children', object: collection, locals: {url: add_child_path, name: name, attributes_key: attributes_key}.merge(options)
    end
    
  end
  
end
