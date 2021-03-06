# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "drs/auth_client/version"

Gem::Specification.new do |spec|
  spec.name          = "drs-auth_client"
  spec.version       = Drs::AuthClient::VERSION
  spec.authors       = ["Jakub Novotny"]
  spec.email         = ["jakub.novotny@digital.justice.gov.uk"]

  spec.summary       = "Defence Request Service Auth service API wrapper"
  spec.description   = ""
  spec.homepage      = "https://github.com/ministryofjustice/defence-request-service-auth"
  spec.license       = "UK Open Government Licence"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec)/}) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "~> 4.2.0"
  spec.add_dependency "faraday", "~> 0.9.1"

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2"
end
