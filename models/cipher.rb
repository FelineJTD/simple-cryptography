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

  def initialize(plaintext, cipher, key, ciphertext)
    @plaintext = plaintext
    @cipher = cipher
    @key = key
    @ciphertext = ciphertext
  end

  def sanitize
    # Throws away everything except a-z, A-Z (26 huruf alfabet)
    # For all ciphers except extended vigenere
    @plaintext = @plaintext.gsub(/[^a-zA-Z]/, '').upcase
    @key = @key.gsub(/[^a-zA-Z]/, '').upcase
    @ciphertext = @ciphertext.gsub(/[^a-zA-Z]/, '').upcase
  end

  def encrypt
    case @cipher
    when 'vigenere'
      vigenere_encrypt
    when 'auto-key'
      auto_key_encrypt
    when 'extended'
      extended_vigenere_encrypt
    when 'playfair'
      playfair_encrypt
    when 'affine'
      affine_encrypt
    when 'hill'
      hill_encrypt
    when 'super'
      super_encrypt
    when 'enigma'
      enigma_encrypt
    else
      @ciphertext = 'Invalid cipher selection'
    end

    @ciphertext
  end

  def decrypt
    case @cipher
    when 'vigenere'
      vigenere_decrypt
    when 'auto-key'
      auto_key_decrypt
    when 'extended'
      extended_vigenere_decrypt
    when 'playfair'
      playfair_decrypt
    when 'affine'
      affine_decrypt
    when 'hill'
      hill_decrypt
    when 'super'
      super_decrypt
    when 'enigma'
      enigma_decrypt
    else
      @plaintext = 'Invalid cipher selection'
    end

    @plaintext
  end

  # ALGO STARTS HERE
  def vigenere_encrypt
    self.sanitize
    @ciphertext = ''
    for i in 0..@plaintext.length-1
      @ciphertext += (((@plaintext[i].ord - 65) + (@key[i % @key.length].ord - 65)) % 26 + 65).chr
    end
  end

  def vigenere_decrypt
    self.sanitize
    @plaintext = ''
    for i in 0..@ciphertext.length-1
      @plaintext += ((((@ciphertext[i].ord - 65) - (@key[i % @key.length].ord - 65)) + 26) % 26 + 65).chr
    end
  end

  def auto_key_encrypt
    @key += @plaintext
    vigenere_encrypt
  end

  def auto_key_decrypt
    self.sanitize
    @plaintext = ''
    for i in 0..@ciphertext.length-1
      if i < key.length
        @plaintext += ((((@ciphertext[i].ord - 65) - (@key[i].ord - 65)) + 26) % 26 + 65).chr
      else
        @plaintext += ((((@ciphertext[i].ord - 65) - (@plaintext[i - @key.length].ord - 65)) + 26) % 26 + 65).chr
      end
    end
  end

  def extended_vigenere_encrypt
    @ciphertext = ''
    for i in 0..@plaintext.length-1
      @ciphertext += (((@plaintext[i].ord - 65) + (@key[i % @key.length].ord - 65)) % 256 + 65).to_s
    end
  end
end
