class Contributors
  include Interactor
  def call
    params = parse_rep_url context.repository_path
    return context.error = true if params.empty?

    connection = Faraday.new(
      url: "https://api.github.com/repos/#{params[1]}/#{params[2]}/contributors",
      headers: {
        Authorization: ENV['GITHUB_TOKEN']
      }
    )
    response = JSON.parse(connection.get.body)
    context.data = {
      top: response[0, 3].map { |contrib| contrib['login']},
      login: params[1],
      repo: params[2]
    }
  end

  def parse_rep_url(url)
    url.scan(%r{.*(github.com)/([a-z-_]+)/([a-z-_]+)}).flatten
  end
end
