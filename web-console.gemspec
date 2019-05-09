require_relative "lib/web_console/version"

Gem::Specification.new do |s|
  s.name = "web-console"
  s.version = WebConsole::VERSION
  s.authors = ["localhostdotdev"] # obviously not original author
  s.email = ["localhostdotdev@protonmail.com"] # same
  s.homepage = "https://github.com/localhostdotdev/web-console"
  s.summary  = "simpler rails web console"
  s.license  = "MIT"
  s.files = `git ls-files`.split("\n")
  s.required_ruby_version = ">= 2.5"

  rails_version = ">= 6.0.0.a"

  s.add_dependency "railties", rails_version
  s.add_dependency "activemodel", rails_version
  s.add_dependency "actionview",  rails_version
  s.add_dependency "bindex", ">= 0.4.0"
end
