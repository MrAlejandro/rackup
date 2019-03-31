require 'rack'
require_relative 'time_formatter'

class App

  ALLOWED_PATHS = ['/time'].freeze

  def call(env)
    @env = env
    return respond_not_found unless allowed_path?
    handle_request
  end

  private

  def allowed_path?
    ALLOWED_PATHS.include?(@env['REQUEST_PATH'])
  end

  def respond_not_found
    [404, {}, []]
  end

  def handle_request
    query_params = Rack::Utils.parse_nested_query(@env['QUERY_STRING'])
    return respond_not_found if query_params['format'].nil?

    time_formatter = TimeFormatter.new
    time_formats = query_params['format'].split(',')
    result = time_formatter.format(time_formats)

    respond(result)
  end


  def respond(result)
    result[:success] ? respond_success(result[:result]) : respond_error(result[:message])
  end

  def respond_success(formatted_time)
    [
        200,
        { 'Content-Type' => 'text/plain' },
        [formatted_time << "\n"]
    ]
  end

  def respond_error(error_message)
    [
        400,
        { 'Content-Type' => 'text/plain' },
        [error_message << "\n"]
    ]
  end
end
