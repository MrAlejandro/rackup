require 'rack'

class App

  ALLOWED_PATHS = ['/time'].freeze
  FORMAT_METHODS_MAPPER = {
    year: :year,
    month: :month,
    day: :day,
    hour: :hour,
    minute: :min,
    second: :sec,
  }

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

    time_formats = query_params['format'].split(',')
    time_parts, unknown_formats = prepare_time_parts(time_formats)
    respond(time_parts, unknown_formats)
  end

  def prepare_time_parts(time_formats)
    time = Time.now
    time_parts = []
    unknown_formats = []

    time_formats.each do |format|
      method = FORMAT_METHODS_MAPPER[format.to_sym]
      if method.nil?
        unknown_formats << format
      else
        time_parts << (time.send method)
      end
    end

    [time_parts, unknown_formats]
  end

  def respond(time_parts, unknown_formats)
    unknown_formats.empty? ? respond_success(time_parts) : respond_error(unknown_formats)
  end

  def respond_success(time_parts)
    [
        200,
        { 'Content-Type' => 'text/plain' },
        [time_parts.join('-') << "\n"]
    ]
  end

  def respond_error(unknown_formats)
    [
        400,
        { 'Content-Type' => 'text/plain' },
        ["Unknown time format [#{unknown_formats.join(', ')}]\n"]
    ]
  end
end
