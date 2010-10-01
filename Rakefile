require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('acts_as_paranoid_versioned', '0.1.0') do |p|
  p.description    = "Paranoid versioning system that keeps versions on initial table."
  p.url            = "http://github.com/"
  p.author         = "Marc Lainez of Belighted"
  p.email          = "ml@belighted.com"
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }

namespace :spec do
  desc "Run all specs"
  Spec::Rake::SpecTask.new('spec') do |t|
    t.spec_files = FileList['spec/**/*_spec.rb']
    t.spec_opts = ['--options', 'spec/spec.opts']
  end
end