require 'zip'
require 'rubygems'
class ZipGenerator
  include Interactor

  def call
    folder = Dir.pwd + '/'
    files = context.data.map { |c| c[:url] }
    return context.error = true if context.data.nil? || files.empty?

    files.each do |f|
      return context.error = true unless File.file?(File.join(folder, f))
    end

    zipfile_name = folder + "public/certificates/#{context.login}/#{context.repo}/#{context.repo}.zip"
    File.delete(zipfile_name) if File.file?(zipfile_name)
    Zip::File.open(zipfile_name, ::Zip::File::CREATE) do |zipfile|
      files.each do |f|
        zipfile.add(f, File.join(folder, f))
      end
    end
    context.url = zipfile_name.gsub(folder, '')
  end
end
