require 'mongo'

module Database
  class << self
    def client
      @client ||= Mongo::Client.new(
        (ENV.fetch('MONGO_HOST') { 'localhost:27017' }).split(/\s*,\s*/),
        database: ENV.fetch('MONGO_DB') { 'repo_certs' },
        user: ENV.fetch('MONGO_USER') { nil },
        password: ENV.fetch('MONGO_PASS') { nil },
        ssl: ENV.fetch('MONGO_SSL') { false }
      )
    end
  end
end