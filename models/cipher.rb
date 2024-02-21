# models/cipher.rb

# a) Vigenere Cipher standard (26 huruf alfabet)
# b) Varian Vigenere Cipher standard (26 huruf alfabet): Auto-Key Vigenere Cipher
# c) Extended Vigenere Cipher (256 karakter ASCII)
# d) Playfair Cipher (26 huruf alfabet)
# e) Affine Cipher (26 huruf alfabet)
# f) Hill Cipher (26 huruf alfabet)
# g) Super enkripsi: gabungan Extended Vigenere Cipher dan cipher transposisi (metode kolom)
# h) Bonus: Enigma Machine (26 huruf alfabet)

class Cipher
  attr_accessor :type, :plaintext, :cipher, :key, :ciphertext, :key_a, :key_b, :matrix_size, :matrix

  def initialize(type, plaintext, cipher, key, ciphertext, key_a, key_b, matrix_size, matrix)
    @type = type
    @plaintext = plaintext
    @cipher = cipher
    @key = key
    @ciphertext = ciphertext
    @key_a = key_a.to_i
    @key_b = key_b.to_i
    @matrix_size = matrix_size
    @matrix = matrix
  end

  def sanitize
    # Throws away everything except a-z, A-Z (26 huruf alfabet)
    # For all ciphers except extended vigenere
    @plaintext = @plaintext.gsub(/[^a-zA-Z]/, '').upcase
    @key = @key.gsub(/[^a-zA-Z]/, '').upcase
    @ciphertext = @ciphertext.gsub(/[^a-zA-Z]/, '').upcase

    if @matrix != ''
      @matrix = @matrix.split(/[,\s]+/).map(&:to_i)
    end
    puts @matrix, "this is matrix"
    puts @matrix_size, "this is matrix size"
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

    if @key == ''
      @ciphertext = 'Invalid key'
      return
    end

    @ciphertext = ''
    for i in 0..@plaintext.length-1
      @ciphertext += (((@plaintext[i].ord - 65) + (@key[i % @key.length].ord - 65)) % 26 + 65).chr
    end
  end

  def vigenere_decrypt
    self.sanitize

    if @key == ''
      @plaintext = 'Invalid key'
      return
    end

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
    if (@type === 'text')
      for i in 0..@plaintext.length-1
        @ciphertext += (((@plaintext[i].ord) + (@key[i % @key.length].ord)) % 256).to_s
      end
    else # file
      for i in 0..10
        puts @plaintext[i].ord
        @ciphertext += (((@plaintext[i].ord) + (@key[i % @key.length].ord)) % 256).to_s
      end
    end
  end

  def extended_vigenere_decrypt

  end

  def playfair_encrypt

  end

  def playfair_decrypt

  end

  def affine_encrypt
    self.sanitize

    puts @key_a, " this is key a"
    puts @key_b, " this is key b"

    if @key_a == '' || @key_b == ''
      @ciphertext = 'Invalid key'
      return
    end

    @ciphertext = ''
    for i in 0..@plaintext.length-1
      @ciphertext += (((@plaintext[i].ord - 65) * @key_a + @key_b) % 26 + 65).chr
    end
  end

  def affine_decrypt
    self.sanitize

    if @key_a == '' || @key_b == ''
      @plaintext = 'Invalid key'
      return
    end

    puts @key_a, " this is key a"
    puts @key_b, " this is key b"

    coef = 1
    for i in 1..25
      if (i * @key_a) % 26 == 1
        coef = i
        break
      end
    end


    @plaintext = ''
    for i in 0..@ciphertext.length-1
      @plaintext += (((@ciphertext[i].ord - 65 - @key_b) * coef) % 26 + 65).chr
    end
  end

  def hill_encrypt
    self.sanitize
  end

  def hill_decrypt
    self.sanitize
  end

  def super_encrypt
    # @GEDE TODO
  end

  def super_decrypt
    # @GEDE TODO
  end

  def enigma_encrypt
    # @GEDE TODO
  end

  def enigma_decrypt
    # @GEDE TODO
  end
end
