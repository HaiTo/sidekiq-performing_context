# Sidekiq::PerformingContext

Sidekiq::PerformingContext is a server-side Sidekiq middleware which provides a way to passing context values when create a job for Sidekiq Jobs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sidekiq-performing_context'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sidekiq-performing_context

## Usage

```ruby
class Worker
  include Sidekiq::Worker
 
  attr_reader :context_attr_1
  attr_reader :context_attr_2
 
  def perform
    @context_attr_1 # => 'sample'
    @context_attr_2 # => 1
    @context_attr_3 # => 'not accessor'

    @performing_context # => {context_attr_1: 'sample', context_attr_2: 1, context_attr_3: 'not accessor'}
  end
end

Worker.with_context(context_attr_1: 'sample', context_attr_2: 1, context_attr_3: 'not accessor').perform_async

````

## Contributing

1. Fork it ( https://github.com/dany1468/sidekiq-performing_context/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

