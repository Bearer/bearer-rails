# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "bearer-rails/version"

Gem::Specification.new do |spec|
  spec.name = "bearer-rails"
  spec.version = BearerRails::VERSION
  spec.authors = ["Bearer Team<engineering@bearer.sh>"]
  spec.email = ["radek@bearer.sh"]

  spec.summary = "Bearer Ruby Rails"
  spec.description = "Bearer Rails helpers"
  spec.homepage = "https://www.bearer.sh"
  spec.licenses = ["MIT"]
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org/"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "~> 5.2.3"
  spec.add_dependency "bearer", "0.2.0"
  spec.add_dependency "openssl", "~> 2.1.2"
  spec.add_dependency "rack", "~> 2.0.6"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "overcommit", "~> 0.46.0"
  spec.add_development_dependency "pry", "~> 0.12.2"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 0.65.0"
end
