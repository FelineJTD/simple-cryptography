# app.rb
require 'sinatra'
require 'base64'
require 'json'

# Load the model
require_relative 'models/cipher'

set :root, File.dirname(__FILE__)

get '/' do
  erb :index
end

post '/encrypt' do
  plaintext = Cipher.new(params[:plaintext], params[:cipher], params[:key], '')
  result = plaintext.encrypt
  { result: result }.to_json
end

post '/decrypt' do
  ciphertext = Cipher.new('', params[:cipher], params[:key], params[:ciphertext])
  result = ciphertext.decrypt
  { result: result }.to_json
end