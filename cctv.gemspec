$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "cctv/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "cctv"
  s.version     = Cctv::VERSION
  s.authors     = ["Lawson Kurtz"]
  s.email       = ["lawson.kurtz@viget.com"]
  s.homepage    = "https://github.com/vigetlabs/cctv"
  s.summary     = "A DynamoDB-backed activity tracker"
  s.license     = "MIT"
  s.description = "CCTV is an ultra-performant, DynamoDB-backed activity tracker."

  s.files = Dir["lib/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "aws-sdk-core", "~> 2"

  s.add_development_dependency "pry"
end
