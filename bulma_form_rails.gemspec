require File.expand_path('lib/bulma_form_rails/version', __dir__)

Gem::Specification.new do |spec|
  spec.name = 'bulma_form_rails'
  spec.version = BulmaForm::VERSION
  spec.authors = ['Kevin Weller']
  spec.email = ['kweller@moderngeosystems.com']
  spec.summary = 'Rails helpers for efficiently building forms with the Bulma CSS library'
  spec.description = 'With this gem, you can efficiently create beautiful index and form pages, and form fields with labels using the Bulma CSS library.  You can also create embedded, editable multi-object subforms.'
  spec.homepage = 'https://github.com/modgeosys/bulma_form_rails'
  spec.license = 'BSD-3-Clause'
  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 3.1.2'
  spec.files = Dir['README.md', 'LICENSE', 'lib/**/*']
end