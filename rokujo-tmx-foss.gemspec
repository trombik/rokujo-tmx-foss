# frozen_string_literal: true

require_relative "lib/rokujo/tmx/foss/version"

Gem::Specification.new do |spec|
  spec.name = "rokujo-tmx-foss"
  spec.version = Rokujo::TMX::FOSS::VERSION
  spec.authors = ["Tomoyuki Sakurai"]
  spec.email = ["y@trombik.org"]

  spec.summary = "Creates translation memory from FOSS project source."
  spec.description = "TODO: Write a longer description or delete this line."
  spec.homepage = "https://github.com/trombik/rokujo-tmx-foss"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.3.0"
  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/trombik/rokujo-tmx-foss"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Uncomment the line below to require MFA for gem pushes.
  # This helps protect your gem from supply chain attacks by ensuring
  # no one can publish a new version without multi-factor authentication.
  # See: https://guides.rubygems.org/mfa-requirement-opt-in/
  # spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/ .github/ .rubocop.yml])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency "dry-cli", "~> 1.1"
  spec.add_dependency "dry-logger", "~> 1.2"
  spec.add_dependency "fiddle", "~> 1.1"
  spec.add_dependency "httpx", "~> 1.8"
  spec.add_dependency "minitar", "~> 1.0"
  spec.add_dependency "ruby-xz", "~> 1.0"
  spec.add_dependency "rubyzip", "~> 3.4"

  # For more information and examples about making a new gem, check out our
  # guide at: https://guides.rubygems.org/make-your-own-gem/
end
