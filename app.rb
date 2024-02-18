# app.rb
require 'sinatra'
require 'base64'

set :root, File.dirname(__FILE__)

post '/encrypt' do
  # Get input type, data, key, and cipher selection
  input_type = params[:input_type]
  input_data = input_type == 'text' ? params[:input_text] : params[:input_file][:tempfile].read
  key = params[:input_key]
  cipher = params[:cipher]

  # Implement encryption logic based on cipher and input type
  # Logic here
  case cipher
  when 'vigenere'
    # Vigenere encryption logic
  when 'auto-key'
    # Auto-Key Vigenere encryption logic
  when 'extended'
    # Extended Vigenere encryption logic
  when 'playfair'
    # Playfair encryption logic
  when 'affine'
    # Affine encryption logic
  when 'hill'
    # Hill encryption logic
  when 'super'
    # Super encryption logic
  when 'enigma'
    # Enigma encryption logic
  else
    flash[:error] = 'Invalid cipher selection'
    redirect '/'
  end

  # Render the result template with encrypted data
  erb :result, locals: { data: encrypted_data }
end

post '/decrypt' do
  # Get input type, data, key, and cipher selection
  # ... (similar to /encrypt)

  # Implement decryption logic based on cipher and input type
  # Logic here
  case cipher
  when 'vigenere'
    # Vigenere encryption logic
  when 'auto-key'
    # Auto-Key Vigenere encryption logic
  when 'extended'
    # Extended Vigenere encryption logic
  when 'playfair'
    # Playfair encryption logic
  when 'affine'
    # Affine encryption logic
  when 'hill'
    # Hill encryption logic
  when 'super'
    # Super encryption logic
  when 'enigma'
    # Enigma encryption logic
  else
    flash[:error] = 'Invalid cipher selection'
    redirect '/'
  end

  # Render the result template with decrypted data
  erb :result, locals: { data: decrypted_data }
end

get '/' do
  @test = "Hello World"
  erb :index
end

get '/temp' do
  erb :temp
end

get '/result' do
  erb :result
end

post '/call_ruby_function' do
  # Call the specific Ruby function in the model
  result = Task.hello_world # Replace with your actual function

  # Return a response (could be JSON, text, etc.)
  text result
end
