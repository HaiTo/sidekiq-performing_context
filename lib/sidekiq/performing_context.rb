require 'sidekiq/performing_context/version'
require 'sidekiq/worker'

module Sidekiq
  module PerformingContext
    OPTION_KEY_NAME = 'performing_context'.freeze

    module WorkerWithContext
      def with_context(contexts)
        raise ArgumentError, 'contexts needs Hash type object' unless Hash === contexts

        self.set(Sidekiq::PerformingContext::OPTION_KEY_NAME => contexts)
      end
    end

    class Middleware
      def call(worker, item, _queue)
        if item.key?(Sidekiq::PerformingContext::OPTION_KEY_NAME)
          worker.instance_variable_set(:@performing_context, item[Sidekiq::PerformingContext::OPTION_KEY_NAME].symbolize_keys)

          item[Sidekiq::PerformingContext::OPTION_KEY_NAME].each do |k, v|
            worker.instance_variable_set("@#{k}", v)
          end
        end

        yield
      end
    end
  end
end

Sidekiq::Worker.class_eval do
  def self.append_features(klass)
    klass.extend Sidekiq::PerformingContext::WorkerWithContext
    super
  end
end

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Sidekiq::PerformingContext::Middleware
  end
end
