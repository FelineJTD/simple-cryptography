# models/cipher.rb

# a) Vigenere Cipher standard (26 huruf alfabet)
# b) Varian Vigenere Cipher standard (26 huruf alfabet): Auto-Key Vigenere Cipher
# c) Extended Vigenere Cipher (256 karakter ASCII)
# d) Playfair Cipher (26 huruf alfabet)
# e) Affine Cipher (26 huruf alfabet)
# f) Hill Cipher (26 huruf alfabet)
# g) Super enkripsi: gabungan Extended Vigenere Cipher dan cipher transposisi (metode kolom)

class Cipher
  attr_accessor :plaintext, :cipher, :key, :ciphertext

  def initialize(plaintext, cipher, key)
    @plaintext = plaintext
    @cipher = cipher
    @key = key
  end

  def sanitize
    # Throws away everything except a-z, A-Z (26 huruf alfabet)
    # For all ciphers except extended vigenere
    @plaintext = @plaintext.gsub(/[^a-zA-Z]/, '').upcase
    @key = @key.gsub(/[^a-zA-Z]/, '').upcase
  end

  def encrypt
    puts "helloooo from encrypt???"
    case @cipher
    when 'vigenere'
      self.sanitize
      @ciphertext = ''
      for i in 0..@plaintext.length-1
        if @plaintext[i] != ' '
          @ciphertext += ((@plaintext[i].ord - 64 + @key[i % @key.length].ord - 64) % 26 + 64).chr
        else
          @ciphertext += ' '
        end
      end
    when 'auto-key'
      @ciphertext = auto_key_encrypt
    when 'extended'
      @ciphertext = extended_vigenere_encrypt
    when 'playfair'
      @ciphertext = playfair_encrypt
    when 'affine'
      @ciphertext = affine_encrypt
    when 'hill'
      @ciphertext = hill_encrypt
    when 'super'
      @ciphertext = super_encrypt
    when 'enigma'
      @ciphertext = enigma_encrypt
    else
      @ciphertext = 'Invalid cipher selection'
    end

    @ciphertext
  end
end
