require 'spec_helper'

describe Sidekiq::PerformingContext do
  class Worker
    include Sidekiq::Worker

    attr_reader :first_attr

    def perform(target_id)

    end
  end

  let!(:spy_worker) { Worker.new }

  before do
    allow(Worker).to receive(:new) { spy_worker }
  end

  example 'perform once' do
    Worker.with_context(first_attr: 999, second_attr: 'second').perform_async(123)

    Sidekiq::Worker.drain_all

    expect(spy_worker.first_attr).to eq(999)
    expect(spy_worker.instance_variable_get(:@second_attr)).to eq('second')

    expect(spy_worker.instance_variable_get(:@performing_context)).to eq(first_attr: 999, second_attr: 'second')
  end

  example 'perform twice' do
    Worker.with_context(first_attr: 999, second_attr: 'second').perform_async(123)

    Sidekiq::Worker.drain_all

    Worker.with_context(first_attr: 'first', second_attr: 777).perform_async(123)

    Sidekiq::Worker.drain_all

    expect(spy_worker.first_attr).to eq('first')
    expect(spy_worker.instance_variable_get(:@second_attr)).to eq(777)

    expect(spy_worker.instance_variable_get(:@performing_context)).to eq(first_attr: 'first', second_attr: 777)
  end

  example 'overwrite context' do
    Worker.with_context(first_attr: 999, second_attr: 'second')
    Worker.with_context(first_attr: 'overwrite first', second_attr: 'overwrite second').perform_async(123)

    Sidekiq::Worker.drain_all

    expect(spy_worker.first_attr).to eq('overwrite first')
    expect(spy_worker.instance_variable_get(:@second_attr)).to eq('overwrite second')

    expect(spy_worker.instance_variable_get(:@performing_context)).to eq(first_attr: 'overwrite first', second_attr: 'overwrite second')
  end
end
