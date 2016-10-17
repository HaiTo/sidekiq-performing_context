$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'sidekiq'
require 'sidekiq/performing_context'
require 'sidekiq/testing'
require 'mock_redis'

RSpec.configure do |config|
  config.before :all do
    Redis.current = MockRedis.new
  end

  config.before do
    Sidekiq::Worker.clear_all
  end

  config.define_derived_metadata do |meta|
    meta[:aggregate_failures] = true unless meta.key?(:aggregate_failures)
  end
end

Sidekiq::Testing.server_middleware do |chain|
  chain.add Sidekiq::PerformingContext::Middleware
end
