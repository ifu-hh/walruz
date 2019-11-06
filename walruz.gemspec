# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'walruz/version'

Gem::Specification.new do |s|
  s.name = %q{walruz}
  s.version = Walruz.version
  s.authors = ["Roman Gonzalez"]
  s.email = %q{roman@noomi.com}
  s.extra_rdoc_files = %w(LICENSE README.rdoc)
  s.files = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  s.homepage = %q{http://github.com/noomii/walruz}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{walruz}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Walruz is a gem that provides an easy but powerful way to implement authorization policies in a system, relying on the composition of simple policies to create more complex ones.}
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  s.add_development_dependency 'rake', '~> 13.0.0'
  s.add_development_dependency 'rspec', '~> 3.9.0'
  s.add_development_dependency 'rspec-collection_matchers', '~> 1.2.0'
  s.add_development_dependency 'yard', '~> 0.9.20'
  s.add_development_dependency 'rdoc', '~> 6.2.0'
end
