require 'bulma_form_rails/field_helpers'
require 'bulma_form_rails/form_page_helpers'
require 'bulma_form_rails/header_and_footer_helpers'
require 'bulma_form_rails/message_box_helpers'
require 'bulma_form_rails/subform_helpers'

module BulmaFormRails
  class Railtie < Rails::Railtie
    railtie_name :bulma_form_rails
    
    rake_tasks do
      path = File.expand_path(__dir__)
      Dir.glob("#{path}/../tasks/**/*.rake").each {|filename| load filename}
    end
    
    VIEW_PATH = 'lib/templates/app/views'
    
    @@bulma_form_initializer = Proc.new do
      ActionView::Helpers.send :include, FieldHelpers
      ActionView::Helpers.send :include, FormPageHelpers
      ActionView::Helpers.send :include, HeaderAndFooterHelpers
      ActionView::Helpers.send :include, MessageBoxHelpers
      ActionView::Helpers.send :include, SubformHelpers

      ActionController::Base.class_eval do
        append_view_path VIEW_PATH
        helper_method :lookup_attributes

        def self.bulma_child_forms(attributes)
          class_eval do
            def add_child
              # Protect against code injection
              if not %r|\A[a-zA-Z_]+\Z|.match(params[:name])
                raise ActiveRecord::RecordNotFound
              end
              @name = params[:name]
              @attributes_key = params[:attributes_key]
              @attributes = lookup_attributes(params[:attributes_key]) unless @attributes_key.blank?
              @size = params[:size].to_i + 1
              respond_to do |format|
                format.turbo_stream do
                  render turbo_stream: turbo_stream.append("#{@name}-table",
                                                           partial: 'bulma_form_rails/child',
                                                           locals: {child: eval("#{@name.capitalize.gsub(/_(.)/) {|s| $1.capitalize }}.new"), child_counter: @size, name: @name, attributes: @attributes, attributes_key: @attributes_key, last: true, container: '', system_controlled: false})
                end
              end
            end

            private
            @@child_attributes = attributes
          end
        end

        def lookup_attributes(key)
          @@child_attributes[key.to_sym]
        end
      end
    end
    
    ActiveSupport.on_load(:action_controller, &@@bulma_form_initializer)
  end
end