lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'graphql_pagination/version'

Gem::Specification.new do |spec|
  spec.name = 'graphql-pagination'
  spec.version = GraphqlPagination::VERSION
  spec.authors = ['Krzysztof Knapik', 'RenoFi Engineering Team']
  spec.email = ['knapo@knapo.net', 'engineering@renofi.com']

  spec.summary = 'Page-based kaminari pagination for graphql.'
  spec.description = 'Page-based kaminari pagination for graphql returning collection and pagination metadata.'
  spec.homepage = 'https://github.com/RenoFi/graphql-pagination'
  spec.license = 'MIT'

  spec.metadata['homepage_uri'] = 'https://github.com/RenoFi/graphql-pagination'
  spec.metadata['source_code_uri'] = 'https://github.com/RenoFi/graphql-pagination'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(bin/|spec/|\.rub)}) }
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.7'

  spec.add_dependency 'graphql', '~> 2.0'

  spec.add_development_dependency 'kaminari-activerecord'
  spec.add_development_dependency 'kaminari-core'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rake'
  spec.add_development_dependency 'rubocop-rspec'
end
