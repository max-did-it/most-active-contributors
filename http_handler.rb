require 'hanami-view'
require 'erubis'
require 'interactor'
require 'faraday'
require 'dotenv'
Dotenv.load
Dir[File.join(File.dirname(__FILE__), 'views', '**', '*.rb')].sort.each { |file| require file }
Dir[File.join(File.dirname(__FILE__), 'interactors', '**', '*.rb')].sort.each { |file| require file }
##
#
class HttpHandler
  def get_contributors(params)
    prepared_data = Contributors.call(
      repository_path: params['repo']
    )
    return { body: nil, status: 301, headers: { 'Location' => '/' } } if prepared_data.error

    pdf = CertsGenerator.call(
      data: prepared_data.data
    )
    return { body: nil, status: 400 } if pdf.error

    zip = ZipGenerator.call(
      data: pdf.certs,
      login: prepared_data.data[:login],
      repo: prepared_data.data[:repo]
    )
    return { body: nil, status: 500 } if zip.error

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
