require 'json'
class HttpServer
  def initialize(handler)
    @handler = handler
  end

  def response(status: 400, headers: { 'Contnet-Type' => 'application/json' }, body: { status: :failed })
    [
      status,
      headers,
      [body]
    ]
  end

  def call(env)
    request = Rack::Request.new(env)
    params = if request.get?
      request.params
    elsif request.post?
      body = request.body.read
      JSON.parse(request.body)
    end
    return response if params.nil?
    case request.path_info
    when '/'
      resp = @handler.home
      return response(resp)
    when '/get_contributors'
      resp = @handler.get_contributors(params)
      return response(resp)
    end
    # request.logger.info("hwllo")
    response
  end
end
