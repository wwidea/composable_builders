$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "composable_builders/version"

Gem::Specification.new do |s|
  s.name          = "composable_builders"
  s.version       = ComposableBuilders::VERSION
  s.platform      = Gem::Platform::RUBY
  s.authors       = ['Aaron Baldwin', 'Brightways Learning']
  s.email         = ["baldwina@brightwayslearning.org"]
  s.homepage      = "https://github.com/wwidea/composable_builders"
  s.summary       = %q{A series of modules that can be combined together to create a customized FormBuilder class.}
  s.description   = %q{A series of modules that can be combined together to create a customized FormBuilder class.}
  s.license       = 'MIT'

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
end
