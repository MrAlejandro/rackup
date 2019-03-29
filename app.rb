class App

  def call(env)
    payload
    [
        200,
        { 'Content-Type' => 'text/plain' },
        ["Welcome aboard! Fucker!\n"]
    ]
  end

  private

  def payload
    sleep 1.3
  end
end
