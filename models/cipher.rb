# models/cipher.rb

# a) Vigenere Cipher standard (26 huruf alfabet)
# b) Varian Vigenere Cipher standard (26 huruf alfabet): Auto-Key Vigenere Cipher
# c) Extended Vigenere Cipher (256 karakter ASCII)
# d) Playfair Cipher (26 huruf alfabet)
# e) Affine Cipher (26 huruf alfabet)
# f) Hill Cipher (26 huruf alfabet)
# g) Super enkripsi: gabungan Extended Vigenere Cipher dan cipher transposisi (metode kolom)

class Cipher
  attr_accessor :plaintext, :cipher, :key, :result

  def initialize(plaintext, cipher, key)
    @plaintext = plaintext
    @cipher = cipher
    @key = key
  end

  def encrypt
    puts "helloooo from encrypt???"
    case @cipher
    when 'vigenere'
      # Asumsi case sensitive (A berarti shift 1, a berarti shift 33)
      @result = ''
      for i in 0..@plaintext.length-1
        if @plaintext[i] != ' '
          @result += ((@plaintext[i].ord - 64 + @key[i % @key.length].ord - 64) % 26 + 64).chr
        else
          @result += ' '
        end
      end
    when 'auto-key'
      @result = auto_key_encrypt
    when 'extended'
      @result = extended_vigenere_encrypt
    when 'playfair'
      @result = playfair_encrypt
    when 'affine'
      @result = affine_encrypt
    when 'hill'
      @result = hill_encrypt
    when 'super'
      @result = super_encrypt
    when 'enigma'
      @result = enigma_encrypt
    else
      @result = 'Invalid cipher selection'
    end

    @result
  end
end
