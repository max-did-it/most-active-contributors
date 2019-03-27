require 'rack'
require 'json'
require 'dotenv'
require_relative 'http_server'
require_relative 'http_handler'
# Run server
Dotenv.load
handler = HttpHandler.new
run HttpServer.new(handler)
