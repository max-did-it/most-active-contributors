require 'hanami-view'
require 'erubis'
require 'interactor'
require 'faraday'
Dir[File.join(File.dirname(__FILE__), 'views', '**', '*.rb')].sort.each { |file| require file }
Dir[File.join(File.dirname(__FILE__), 'interactors', '**', '*.rb')].sort.each { |file| require file }
##
#
class HttpHandler
  def get_contributors(params)
    prepared_data = Contributors.call(
      repository_path: params['repo']
    )
    pdf = CertsGenerator.call(
      data: prepared_data.data
    )

    zip = ZipGenerator.call(
      data: pdf.certs,
      login: prepared_data.data[:login],
      repo: prepared_data.data[:repo]
    )

    body = GetContributors::Show.render(format: :html, zip: zip.url, certs: pdf.certs)
    status = 200
    { body: body, status: status }
  end

  def home
    body = Home::Show.render(format: :html)
    status = 200
    { body: body, status: status }
  end
end
