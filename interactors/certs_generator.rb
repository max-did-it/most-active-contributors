require 'prawn'
class CertsGenerator
  include Interactor

  def call
    context.certs = []
    return context.error = true if context.data.nil? || context.data[:top].empty?

    context.data[:top].each do |name|
      url = generate_pdf(name) unless cert_exist? name
      context.certs << { url: url, owner: name }
    end
  end

  def cert_exist?(name)
    file_path = Dir.pwd + "public/certificates/#{context.data[:login]}/#{context.data[:repo]}/#{name}.pdf"
    File.file? file_path
  end

  def generate_pdf(name)
    create_dir
    dir = get_path_to_certs
    rep_name = context.data[:repo].capitalize
    Prawn::Document.generate(dir + '/' + name + '.pdf') do
      text "
        Thank you, #{name}!
        Your contribution to #{rep_name}
                    is the biggest!!!
      "
    end

    "public/certificates/#{context.data[:login]}/#{context.data[:repo]}/#{name}.pdf"
  end

  def get_path_to_certs
    Dir.pwd + '/public/' + 'certificates/' + context.data[:login] + '/' + context.data[:repo]
  end

  def create_dir
    dirname = get_path_to_certs
    splited = dirname.split(%r{[/]})
    curr_path = []
    splited.each do |n|
      curr_path << n
      Dir.mkdir('/' + curr_path.join('/')) unless Dir.exist?('/' + curr_path.join('/'))
    end
  end
end
