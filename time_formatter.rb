class TimeFormatter
  FORMATS_MAPPER = {
      year: '%Y',
      month: '%m',
      day: '%d',
      hour: '%H',
      minute: '%M',
      second: '%S',
  }

  def format(time_formats)
    time_parts, unknown_formats = prepare_time_parts(time_formats)
    unknown_formats.empty? ? successful_result(time_parts) : failed_result(unknown_formats)
  end

  def prepare_time_parts(time_formats)
    formats = []
    unknown_formats = []

    time_formats.each do |format|
      format = FORMATS_MAPPER[format.to_sym]
      if format.nil?
        unknown_formats << format
      else
        formats << format
      end
    end

    [formats, unknown_formats]
  end

  def successful_result(formats)
    {
      success: true,
      result: Time.now.strftime(formats.join('-')),
    }
  end

  def failed_result(unknown_formats)
    {
      success: false,
      message: "Unknown time format [#{unknown_formats.join(', ')}]",
    }
  end
end
