# frozen_string_literal: true

require 'rails/generators'

module BulmaFormRails
  module Generators
    class PagyConfigGenerator < Rails::Generators::Base
      source_root File.expand_path('../../templates', __FILE__)
      
      def copy_pagy_config
        copy_file File.join(Gem.loaded_specs['bulma_form_rails'].full_gem_path, 'lib', 'templates', 'config', 'initializers', 'pagy.rb'), File.join('config', 'initializers', 'pagy.rb')
      end
    end
  end
end