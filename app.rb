require 'rack'
require_relative 'time_formatter'

class App
  ERROR_NOT_FOUND = 400
  ERROR_BAD_REQUEST = 400

  PATHS_HANDLERS = {
    '/time' => :handle_time_request,
  }

  def call(env)
    @request = Rack::Request.new(env)
    return respond_with_error(ERROR_NOT_FOUND) unless allowed_path?
    send PATHS_HANDLERS[@request.path]
  end

  private

  def allowed_path?
    !PATHS_HANDLERS[@request.path].nil?
  end

  def respond_with_error(error_code)
    [error_code, {}, []]
  end

  def handle_time_request
    query_params = @request.params
    return respond_with_error(ERROR_BAD_REQUEST) if query_params['format'].nil?

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
