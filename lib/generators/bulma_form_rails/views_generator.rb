# frozen_string_literal: true

require 'rails/generators'

module BulmaFormRails
  module Generators
    class ViewsGenerator < Rails::Generators::Base
      source_root File.expand_path('../../templates', __FILE__)
      
      def copy_views
        gem_directory =  File.join(Gem.loaded_specs['bulma_form_rails'].full_gem_path, 'lib', 'templates', 'app', 'views', 'bulma_form_rails')
        app_directory = File.join('app', 'views', 'bulma_form_rails')
        Dir.each_child(gem_directory) do |template_file| 
          copy_file File.join(gem_directory, template_file), File.join(app_directory, template_file)
        end
      end
    end
  end
end