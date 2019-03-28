require_relative Dir.pwd + '/http_handler'
require 'fileutils'
RSpec.describe HttpHandler do
  describe 'when get home page' do
    let(:handler) { HttpHandler.new }

    it 'ping test to static status code' do
      response = handler.home
      expect(response[:status]).to eq 200
    end

    it 'should raise when to #home given params' do
      expect { handler.home [nil, nil] }.to raise_error(ArgumentError)
    end
  end

  describe 'HttpHandler#get_contributors method' do
    let(:handler) { HttpHandler.new }

    context 'when #get_contributors correct' do
      let(:correct_params) { { 'repo' => 'https://github.com/rails/rails' } }
      before do
        dir = Dir.pwd + '/public/certificates/rails'
        FileUtils.rm_r  dir if Dir.exist? dir 
      end
      after do
        dir = Dir.pwd + '/public/certificates/rails'
        FileUtils.rm_r  dir if Dir.exist? dir 
      end
      it 'should create pdf' do
        handler.get_contributors correct_params
        expect(Dir[Dir.pwd + '/public/certificates/rails/rails/*.pdf'].empty?).to eq false
      end

      it 'should create zip' do
        handler.get_contributors correct_params
        expect(Dir[Dir.pwd + '/public/certificates/rails/rails/*.zip'].count).to eq 1
      end
    end

    context 'when url to repo uncorrect' do
      let(:uncorrect_params) { { 'repo' => 'https://gitlab.com/SiberianPanda/most-active-contributors' } }

      it 'should return redirect status' do
        result = handler.get_contributors uncorrect_params
        expect(result[:status]).to eq 301
      end

      it 'should return redirect status' do
        result = handler.get_contributors uncorrect_params
        expect(result[:headers]['Location']).to eq '/'
      end
    end
  end
end
