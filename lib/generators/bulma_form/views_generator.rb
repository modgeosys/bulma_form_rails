# frozen_string_literal: true

require 'rails/generators'

module BulmaForm
  module Generators
    class ViewsGenerator < Rails::Generators::Base
      source_root File.expand_path('../../bulma_form_rails/views', __FILE__)
      
      def copy_views
        copy_file File.join(Gem.loaded_specs['bulma_form_rails'].full_gem_path, 'lib', 'bulma_form_rails', 'views'), File.join('app', 'views', 'bulma_form_rails')
      end
    end
  end
end