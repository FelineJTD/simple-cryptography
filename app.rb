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
  puts params
  plaintext = Cipher.new(params[:type], params[:plaintext], params[:cipher], params[:key], '', params[:affine_key_a], params[:affine_key_b], params[:matrix_size], params[:matrix])
  result = plaintext.encrypt
  { result: result }.to_json
end

post '/decrypt' do
  ciphertext = Cipher.new(params[:type], '', params[:cipher], params[:key], params[:ciphertext], params[:affine_key_a], params[:affine_key_b], params[:matrix_size], params[:matrix])
  result = ciphertext.decrypt
  { result: result }.to_json
end
