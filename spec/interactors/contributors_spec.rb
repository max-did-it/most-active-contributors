require_relative Dir.pwd + '/interactors/contributors'
RSpec.describe Contributors do
  context 'when url correct' do
    let(:repo_url) { 'https://github.com/rails/rails' }
    it 'should return top array' do
      result = Contributors.call(
        repository_path: repo_url
      )
      expect(result.data[:top].map(&:class)).to eq result.data[:top].count.times.map { String }
    end
  end
end
