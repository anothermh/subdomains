# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'subdomains/version'

Gem::Specification.new do |spec|
  spec.name          = "subdomains"
  spec.version       = Subdomains::VERSION
  spec.authors       = ["anothermh"]
  spec.email         = ["another.mhodges@gmail.com"]

  spec.summary       = %q{Parses the subdomains out of a given string.}
  spec.description   = %q{Sometimes you just need to get "example.com" out of "https://www.example.com/?example=example" without raising exceptions and this makes it simple to do just that.}
  spec.homepage      = "https://github.com/anothermh/subdomains"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Required for domain parsing; versions are named with dates, e.g., "0.5.2016-06-15T16:22:11Z"
  # so we will accept any version below v0.6
  spec.add_dependency "domain_name", "< 0.6"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
