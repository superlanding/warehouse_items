
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "warehouse/version"

Gem::Specification.new do |spec|
  spec.name          = "warehouse_items"
  spec.version       = Warehouse::VERSION
  spec.authors       = ["Eddie Li"]
  spec.email         = ["eddie@super-landing.com"]

  spec.summary       = %q{warehouse_items wrapper & value objects}
  spec.description   = %q{warehouse_items wrapper & value objects}
  spec.homepage      = "https://github.com/superlanding/warehouse_items"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 2.7"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 1.16"
  spec.add_development_dependency "rake", ">= 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "shoulda-context"

  spec.add_dependency "activesupport"
end
