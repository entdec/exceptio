# Exceptio
Short description and motivation.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'exceptio'
```



Add to ApplicationController

`rescue_from StandardError, with: :error_render_method`

```ruby
def error_render_method(exception)
  Exceptio::ExceptionRecordingService.new(exception).call

  respond_to do |type|
    type.html do
      begin
        render template: '/exception', status: 500
      rescue StandardError
        render template: '/exception', layout: 'exception', status: 500
      end
      false
    end
    type.js { render json: { error: 'internal server error' }, status: 500 } # FIXME: Check if this is handy.
    type.all { render nothing: true, status: 500 }
  end
end
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
