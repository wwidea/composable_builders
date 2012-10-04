require File.expand_path('../lib/composable_builders/version', __FILE__)

Gem::Specification.new do |s|
  s.name = "composable_builders"
  s.version = ComposableBuilders::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ["Jonathan S. Garvin", 'Aaron Baldwin', 'WWIDEA, Inc']
  s.email = ["developers@wwidea.org"]
  s.homepage = "https://github.com/wwidea/composable_builders"
  s.summary = %q{A series of modules that can be combined together to create a customized FormBuilder class.}
  s.description = %q{A series of modules that can be combined together to create a customized FormBuilder class.}

  s.add_development_dependency('rake','>= 0.9.2')
  s.add_development_dependency('rdoc','>= 3.12')
  s.add_development_dependency('activesupport')

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- test/*`.split("\n")
  s.require_paths = ["lib"]
end