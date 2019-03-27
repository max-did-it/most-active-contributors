require 'hanami-view'
require 'erubis'
require 'interactor'
require 'faraday'
Dir[File.join(File.dirname(__FILE__), 'views', '**', '*.rb')].sort.each { |file| require file }
Dir[File.join(File.dirname(__FILE__), 'interactors', '**', '*.rb')].sort.each { |file| require file }
Dir[File.join(File.dirname(__FILE__), 'graphql', 'queries', '*.rb')].sort.each { |file| require file }
##
#
class HttpHandler
  def get_contributors(params)
    prepared_data = Contributors.call(
      repository_path: params['repo']
    )
    result = CertsGenerator.call(
      data: prepared_data.data
    )

    body = GetContributors::Show.render(format: :html, data: result.data)
    status = 200
    { body: body, status: status }
  end

  def home
    body = Home::Show.render(format: :html)
    status = 200
    { body: body, status: status }
  end
end
