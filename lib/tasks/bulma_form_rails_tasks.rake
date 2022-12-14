def run_template_path(path)
  system "#{RbConfig.ruby} ./bin/rails app:template LOCATION=#{File.expand_path("../install/#{path}.rb", __dir__)}"
end

def stimulus_installed?
  (Rails.root.join("app/javascript/controllers/index.js")).exist?
end

def switch_on_stimulus
  Rake::Task["webpacker:install:stimulus"].invoke
end

def switch_on_turbo
  Rake::Task["turbo:install"].invoke
end

namespace :bulma_form_rails do
  desc "Install bulma_form_rails packages"
  task install: %i[stimulus turbo] do
    run_template_path "bulma_form_rails"
  end

  task :stimulus do
    switch_on_stimulus unless stimulus_installed?
  end

  task :turbo do
    switch_on_turbo
  end
end