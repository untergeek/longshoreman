Gem::Specification.new do |s|
  s.name          = 'longshoreman'
  s.version       = '0.0.7'
  s.summary       = 'A helper Gem for using the Docker API'
  s.description   = 'This gem is intended to aid in using Docker images and containers, specifically with regards to integration testing in RSpec.'
  s.authors       = ['Aaron Mildenstein', 'Tal Levy']
  s.email         = 'aaron@mildensteins.com'
  s.homepage      = 'http://github.com/untergeek/longshoreman'
  s.licenses      = ['Apache License (2.0)']
  s.require_paths = ['lib']

  # Files
  s.files = ['lib/longshoreman.rb', 'lib/longshoreman/container.rb', 'lib/longshoreman/image.rb', ]

  # Dependencies
  s.add_runtime_dependency 'docker-api', '~> 1.0', '>= 1.21.4'
end
