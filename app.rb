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
  plaintext = Cipher.new(params[:plaintext], params[:cipher], params[:key])
  result = plaintext.encrypt
  { result: result }.to_json
end

# post '/encrypt' do
#   # Get input type, data, key, and cipher selection
#   input_type = params[:input_type]
#   input_data = input_type == 'text' ? params[:input_text] : params[:input_file][:tempfile].read
#   key = params[:input_key]
#   cipher = params[:cipher]

#   # Implement encryption logic based on cipher and input type
#   # Logic here
#   case cipher
#   when 'vigenere'
#     # Vigenere encryption logic
#   when 'auto-key'
#     # Auto-Key Vigenere encryption logic
#   when 'extended'
#     # Extended Vigenere encryption logic
#   when 'playfair'
#     # Playfair encryption logic
#   when 'affine'
#     # Affine encryption logic
#   when 'hill'
#     # Hill encryption logic
#   when 'super'
#     # Super encryption logic
#   when 'enigma'
#     # Enigma encryption logic
#   else
#     flash[:error] = 'Invalid cipher selection'
#     redirect '/'
#   end

#   # Render the result template with encrypted data
#   erb :result, locals: { data: encrypted_data }
# end

# post '/decrypt' do
#   # Get input type, data, key, and cipher selection
#   # ... (similar to /encrypt)

#   # Implement decryption logic based on cipher and input type
#   # Logic here
#   case cipher
#   when 'vigenere'
#     # Vigenere encryption logic
#   when 'auto-key'
#     # Auto-Key Vigenere encryption logic
#   when 'extended'
#     # Extended Vigenere encryption logic
#   when 'playfair'
#     # Playfair encryption logic
#   when 'affine'
#     # Affine encryption logic
#   when 'hill'
#     # Hill encryption logic
#   when 'super'
#     # Super encryption logic
#   when 'enigma'
#     # Enigma encryption logic
#   else
#     flash[:error] = 'Invalid cipher selection'
#     redirect '/'
#   end

#   # Render the result template with decrypted data
#   erb :result, locals: { data: decrypted_data }
# end
