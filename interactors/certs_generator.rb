require 'prawn'
require 'fileutils'
require 'bson'
require_relative Dir.pwd + '/mongo/client.rb'
class CertsGenerator
  include Interactor

  def call
    filter = [
      {
        repo: context.data[:repo],
        login: context.data[:login],
        users: { name: context.data[:top] }
      },
      {
        'projection' =>
        {
          'users' => 1
        }
      }
    ]
    context.client = Database.client['repo_certs']
    context.certs = context.client.find(*filter).to_h
    context.data[:top].each do |name|
      generate_pdf name
    end
  end

  def generate_pdf(name)
    create_dir
    dir = get_path_to_certs

    Prawn::Document.generate(dir + '/' + name + '.pdf') do
      text "
        Thank you, #{name}!
        Your contribution to #{context.data[:repo].capitalize}
                   is the biggest!!!
      "
    end

    filter = [
      {
        repo: context.data[:repo],
        login: context.data[:login]
      }

    ]
    repo = context.client.find(filter).first

    if repo
      new_filter = [{
        repo: context.data[:repo],
        login: content.data[:login]
      },
                    {
                      '$push' => {
                        users: {
                          _id: BSON::ObjectId.new,
                          name: context.data[:login],
                          cert: {
                            _id: BSON::ObjectId.new,
                            full_path: dir + '/' + name,
                            url_path: "public/certs/#{content.data[:login]}/#{context.data[:repo]}/#{name}.pdf"
                          }
                        }
                      }
                    }]
      context.client.find_one_and_update(*new_filter)
    else
      data = {
        _id: BSON::ObjectId.new,
        repo: context.data[:repo],
        login: content.data[:login],
        users: [{
          _id: BSON::ObjectId.new,
          name: context.data[:login],
          cert: {
            _id: BSON::ObjectId.new,
            full_path: dir + '/' + name,
            url_path: "public/certs/#{content.data[:login]}/#{context.data[:repo]}/#{name}.pdf"
          }
        }]
      }
      context.client.insert_one(data)
    end
    "public/certs/#{content.data[:login]}/#{context.data[:repo]}/#{name}.pdf"
  end

  def get_path_to_certs
    Dir.pwd + '/public/' + context.data[:login] + '/' + context.data[:repo]
  end

  def create_dir
    dirname = get_path_to_certs
    splited = dirname.split(%r{[/]})
    curr_path = []
    puts '/' + curr_path.join('/')
    splited.each do |n|
      curr_path << n
      Dir.mkdir('/' + curr_path.join('/')) unless Dir.exist?('/' + curr_path.join('/'))
    end
  end
end
