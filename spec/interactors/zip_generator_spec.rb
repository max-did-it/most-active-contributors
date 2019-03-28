require_relative Dir.pwd + '/interactors/zip_generator'
require 'fileutils'
RSpec.describe ZipGenerator do
  context 'when files exist' do
    before do
      @login = 'someLogin'
      @repo = 'someRepo'
      folder = Dir.pwd + '/public/certificates/' + @login
      Dir.mkdir(folder) unless Dir.exist?(folder)
      folder += '/' + @repo
      Dir.mkdir(folder) unless Dir.exist?(folder)
      counter = 0
      @files = 3.times.map do
        counter += 1
        f = File.open(folder + "/some#{counter}.txt", 'w')
        f.close
        { name: 'Something', url: folder.gsub(Dir.pwd + '/', '') + "/some#{counter}.txt" }
      end
    end

    after do
      FileUtils.rm_r(Dir.pwd + '/public/certificates/' + @login)
    end

    it 'should create zip' do
      result = ZipGenerator.call(
        data: @files,
        login: @login,
        repo: @repo
      )
      expect(File.file?(Dir.pwd + '/' + result.url)).to be true
    end
  end
  context 'when file not exist' do
    it 'should return error' do
      expect(ZipGenerator.call(data: []).error).to be true
    end
  end
end
