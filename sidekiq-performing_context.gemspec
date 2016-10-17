lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sidekiq/performing_context/version'

Gem::Specification.new do |spec|
  spec.name          = 'sidekiq-performing_context'
  spec.version       = Sidekiq::PerformingContext::VERSION
  spec.authors       = ['dany1468']
  spec.email         = ['dany1468@gmail.com']

  spec.summary       = 'Passing context values when create a job for Sidekiq Jobs'
  spec.description   = 'Passing context values when create a job for Sidekiq Jobs'
  spec.homepage      = 'https://github.com/dany1468/sidekiq-performing_context'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'sidekiq', '>= 4.1.0'

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'mock_redis'
end
