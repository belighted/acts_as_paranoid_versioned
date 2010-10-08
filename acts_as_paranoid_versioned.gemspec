# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{acts_as_paranoid_versioned}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Marc Lainez of Belighted"]
  s.date = %q{2010-10-08}
  s.description = %q{Paranoid versioning system that keeps versions on initial table.}
  s.email = %q{ml@belighted.com}
  s.extra_rdoc_files = ["README.rdoc", "lib/acts_as_paranoid_versioned.rb"]
  s.files = ["README.rdoc", "Rakefile", "acts_as_paranoid_versioned.gemspec", "init.rb", "lib/acts_as_paranoid_versioned.rb", "spec/acts_as_paranoid_versioned_spec.rb", "spec/spec_helper.rb", "Manifest"]
  s.homepage = %q{http://github.com/}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Acts_as_paranoid_versioned", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{acts_as_paranoid_versioned}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Paranoid versioning system that keeps versions on initial table.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
