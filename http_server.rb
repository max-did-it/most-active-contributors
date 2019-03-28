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
               JSON.parse(body)
    end

    return response if params.nil?

    case request.path_info
    when '/'
      resp = @handler.home
      return response(resp)
    when '/get_contributors'
      resp = @handler.get_contributors(params)
      return response(resp)
    else

      pdf_url = request.path_info.scan %r{/(public)/(certificates)/([0-9A-Za-z\-_]+)/([0-9A-Za-z\-_]+)/([0-9A-Za-z\-_]+\.pdf)}
      unless pdf_url.empty?
        return response unless File.file?(Dir.pwd + request.path_info)

        return response(
          headers: {
            'Content-Type' => 'application/pdf'
          },
          body: File.open(Dir.pwd + request.path_info).read,
          status: 200
        )
      end
      zip_url = request.path_info.scan %r{/(public)/(certificates)/([0-9A-Za-z\-_]+)/([0-9A-Za-z\-_]+)/([0-9A-Za-z\-_]+\.zip)}
      unless zip_url.empty?
        return response unless File.file?(Dir.pwd + request.path_info)

        return response(
          headers: {
            'Content-Type' => 'application/zip'
          },
          body: File.open(Dir.pwd + request.path_info).read,
          status: 200
        )
      end

    end
    response
  end
end
