class Runtime
  def initialize(app)
    @app = app
  end

  def call(env)
    start = Time.now
    statue, headers, body = @app.call(env)
    headers['X-Runtime'] = "%f" % (Time.now - start)

    [statue, headers, body]
  end
end
