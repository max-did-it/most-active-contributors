require_relative Dir.pwd + '/interactors/certs_generator'
require 'faraday'
require 'dotenv'
require 'fileutils'
Dotenv.load
RSpec.describe CertsGenerator do
  context 'when top empty or not given' do
    it 'should return error' do
      result = CertsGenerator.call(
        top: []
      )
      expect(result.error).to eq true
    end
    it 'should return error' do
      result = CertsGenerator.call
      expect(result.error).to eq true
    end
  end

  context 'when data given' do
    before do
      @dir = Dir.pwd + '/public/certificates/github/graphql-client'
      FileUtils.rm_r(@dir) unless Dir.exist? @dir 
      connection = Faraday.new(
        url: 'https://api.github.com/repos/github/graphql-client/contributors',
        headers: {
          Authorization: ENV['GITHUB_TOKEN']
        }
      )
      response = JSON.parse(connection.get.body)
      @data = {
        top: response[0, 3].map { |contrib| contrib['login'] },
        login: 'github',
        repo: 'graphql-client'
      }
    end
    it 'should create pdf' do
      CertsGenerator.call(
        data: @data
      )
      files = Dir[@dir + '/*.pdf']
      expect(files.empty?).to eq false
    end
  end
end
