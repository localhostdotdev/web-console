require_relative "lib/web_console/version"

Gem::Specification.new do |s|
  s.name = "web-console"
  s.version = WebConsole::VERSION
  s.authors = ["localhostdotdev"] # obviously not original author
  s.email = ["localhostdotdev@protonmail.com"] # same
  s.homepage = "https://github.com/localhostdotdev/web-console"
  s.summary = "simpler rails web console"
  s.license = "MIT"
  s.files = `git ls-files`.split("\n")
  s.required_ruby_version = ">= 2.5"

  rails_version = ">= 6.0.0.a"

  s.add_dependency "railties", rails_version
  s.add_dependency "activemodel", rails_version
  s.add_dependency "actionview",  rails_version
  s.add_dependency "slim-rails", "~> 3.2.0"
  s.add_dependency "temple", "~> 0.8.1"
  s.add_dependency "stimulusjs-rails", "~> 1.1.1"
  s.add_dependency "bindex", ">= 0.4.0"
end
