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
  plaintext = Cipher.new(params[:plaintext], params[:cipher], params[:key], '', params[:affine_key_a], params[:affine_key_b])
  result = plaintext.encrypt
  { result: result }.to_json
end

post '/decrypt' do
  puts params
  ciphertext = Cipher.new('', params[:cipher], params[:key], params[:ciphertext], params[:affine_key_a], params[:affine_key_b])
  result = ciphertext.decrypt
  { result: result }.to_json
end