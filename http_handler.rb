require 'hanami-view'
require 'erubis'

Dir[File.join(File.dirname(__FILE__), 'views', '**', '*.rb')].sort.each { |file| require file }
Dir[File.join(File.dirname(__FILE__), 'interactors', '**', '*.rb')].sort.each { |file| require file }
Dir[File.join(File.dirname(__FILE__), 'graphql', 'queries', '*.rb')].sort.each { |file| require file }
##
#
class HttpHandler

  def get_contributors(params)
    response = Contributors.call(
      repository_path: params["repo"]
    )
    zip = nil
    serts = nil

    body = GetContributors::Show.render(format: :html, zip: zip, serts: serts)
    status = 200
    { body: body, status: status }
  end

  def home
    body = Home::Show.render(format: :html)
    status = 200
    { body: body, status: status }
  end
end
