class TimeFormatter
  FORMAT_METHODS_MAPPER = {
      year: :year,
      month: :month,
      day: :day,
      hour: :hour,
      minute: :min,
      second: :sec,
  }

  def format(time_formats)
    time_parts, unknown_formats = prepare_time_parts(time_formats)
    unknown_formats.empty? ? successful_result(time_parts) : failed_result(unknown_formats)
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

  def successful_result(time_parts)
    {
      success: true,
      result: time_parts.join('-'),
    }
  end

  def failed_result(unknown_formats)
    {
      success: false,
      message: "Unknown time format [#{unknown_formats.join(', ')}]",
    }
  end
end
