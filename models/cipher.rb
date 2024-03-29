# models/cipher.rb

# a) Vigenere Cipher standard (26 huruf alfabet)
# b) Varian Vigenere Cipher standard (26 huruf alfabet): Auto-Key Vigenere Cipher
# c) Extended Vigenere Cipher (256 karakter ASCII)
# d) Playfair Cipher (26 huruf alfabet)
# e) Affine Cipher (26 huruf alfabet)
# f) Hill Cipher (26 huruf alfabet)
# g) Super enkripsi: gabungan Extended Vigenere Cipher dan cipher transposisi (metode kolom)
# h) Bonus: Enigma Machine (26 huruf alfabet)

require 'matrix'

class Cipher
  attr_accessor :type, :plaintext, :cipher, :key, :ciphertext, :key_a, :key_b, :matrix_size, :matrix, :file_extension

  def initialize(type, plaintext, cipher, key, ciphertext, key_a, key_b, matrix_size, matrix, file_extension)
    @type = type
    @plaintext = plaintext
    @cipher = cipher
    @key = key
    @ciphertext = ciphertext
    @key_a = key_a.to_i
    @key_b = key_b.to_i
    @matrix_size = matrix_size.to_i
    @matrix = matrix
    @file_extension = file_extension
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
  end

  def parse_keyword_playfair
    alphabets = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']
    # Sanitize j
    @key = @key.gsub('J', '').upcase
    # Extract unique letters
    key_array = []
    for i in 0..@key.length-1
      if !key_array.include?(@key[i])
        key_array.append(@key[i])
      end
    end
    # Add all other alphabets
    for i in 0..25
      if !key_array.include?(alphabets[i])
        key_array.append(alphabets[i])
      end
    end
    # Parse as matrix
    @matrix = Matrix.build(5) { |row, col| key_array[row * 5 + col] }
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
    if (@type === 'text')
      @ciphertext = []
      for i in 0..@plaintext.length-1
        @ciphertext.append(((@plaintext[i].ord) + (@key[i % @key.length].ord)) % 256)
      end
    else # file
      @ciphertext = []
      for i in 0..@plaintext.length-1
        @ciphertext.append((@plaintext[i.to_s].to_i + @key[i % @key.length].ord) % 256)
      end
    end
  end

  def extended_vigenere_decrypt
    if (@type === 'text')
      @plaintext = []
      for i in 0..@ciphertext.length-1
        @plaintext.append(((@ciphertext[i].ord) - (@key[i % @key.length].ord) + 256) % 256)
      end
    else # file
      @plaintext = []
      for i in 0..@ciphertext.length-1
        @plaintext.append(((@ciphertext[i.to_s].to_i - @key[i % @key.length].ord) + 256) % 256)
      end
    end
  end

  def playfair_encrypt
    self.sanitize
    self.parse_keyword_playfair

    # replace J with I
    @plaintext = @plaintext.gsub('J', 'I')

    # encrypt
    @ciphertext = ''

    while @plaintext.length > 0
      # if odd length, add X
      if @plaintext.length == 1
        @plaintext += 'X'
      end
      # if same letter, insert X
      if @plaintext[0] == @plaintext[1]
        @plaintext = @plaintext[0, 1] + 'X' + @plaintext[1, @plaintext.length]
      end
      # first letter
      idx1 = @matrix.find_index(@plaintext[0])
      # second letter
      idx2 = @matrix.find_index(@plaintext[1])

      # same row
      if idx1[0] == idx2[0]
        @ciphertext += @matrix[idx1[0], (idx1[1] + 1) % 5]
        @ciphertext += @matrix[idx2[0], (idx2[1] + 1) % 5]
      # same column
      elsif idx1[1] == idx2[1]
        @ciphertext += @matrix[(idx1[0] + 1) % 5, idx1[1]]
        @ciphertext += @matrix[(idx2[0] + 1) % 5, idx2[1]]
      # different row and column
      else
        @ciphertext += @matrix[idx1[0], idx2[1]]
        @ciphertext += @matrix[idx2[0], idx1[1]]
      end
      # remove first two letters
      @plaintext = @plaintext[2, @plaintext.length]
    end
  end

  def playfair_decrypt
    self.sanitize
    self.parse_keyword_playfair

    # replace J with I (shouldn't be necessary, but just in case)
    @ciphertext = @ciphertext.gsub('J', 'I')

    # encrypt
    @plaintext = ''

    while @ciphertext.length > 0
      # if odd length, add X (also shouldn't be necessary, but just in case)
      if @ciphertext.length == 1
        @ciphertext += 'X'
      end
      # if same letter, the ciphertext really is broken.
      if @ciphertext[0] == @ciphertext[1]
        @plaintext = 'Invalid ciphertext'
        return
      end
      # first letter
      idx1 = @matrix.find_index(@ciphertext[0])
      # second letter
      idx2 = @matrix.find_index(@ciphertext[1])

      # same row
      if idx1[0] == idx2[0]
        @plaintext += @matrix[idx1[0], (idx1[1] - 1 + 5) % 5]
        @plaintext += @matrix[idx2[0], (idx2[1] - 1 + 5) % 5]
      # same column
      elsif idx1[1] == idx2[1]
        @plaintext += @matrix[(idx1[0] - 1 + 5) % 5, idx1[1]]
        @plaintext += @matrix[(idx2[0] - 1 + 5) % 5, idx2[1]]
      # different row and column
      else
        @plaintext += @matrix[idx1[0], idx2[1]]
        @plaintext += @matrix[idx2[0], idx1[1]]
      end
      # remove first two letters
      @ciphertext = @ciphertext[2, @ciphertext.length]
    end
  end

  def affine_encrypt
    self.sanitize

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

    if (@matrix_size ** 2) != @matrix.length
      @ciphertext = "Incorrect matrix size or input"
      return
    end

    if @plaintext.length % @matrix_size != 0
      for i in 0..(@plaintext.length % @matrix_size) - 1
        @plaintext += 'X'
      end
    end

    substrings = @plaintext.scan(/.{1,#{@matrix_size}}/)

    for substring_idx in 0..substrings.length-1 # this loops for every substring
      for row_idx in 0..@matrix_size-1 # this loops for the encryption matrix row
        temp_ord_value = 0
        for col_idx in 0..@matrix_size-1 # this loops for the encryption matrix column
          selected_substring = substrings[substring_idx]
          temp_ord_value += @matrix[@matrix_size * row_idx + col_idx] * ((selected_substring[col_idx]).ord - 65)
        end
        @ciphertext[@matrix_size * substring_idx + row_idx] = (temp_ord_value % 26 + 65).chr
      end
    end
  end

  def hill_decrypt
    self.sanitize

    if (@matrix_size ** 2) != @matrix.length
      @ciphertext = "Incorrect matrix size or input"
      return
    end

    if @plaintext.length % @matrix_size != 0
      for i in 0..(@plaintext.length % @matrix_size) - 1
        @plaintext += 'X'
      end
    end

    inverse_matrix = Matrix.[](*@matrix.each_slice(@matrix_size).to_a).inverse

    # Convert inverse_matrix back to 1D array
    inverse_matrix = inverse_matrix.to_a.flatten

    substrings = @ciphertext.scan(/.{1,#{@matrix_size}}/)

    for substring_idx in 0..substrings.length-1 # this loops for every substring
      for row_idx in 0..@matrix_size-1 # this loops for the encryption matrix row
        temp_ord_value = 0
        for col_idx in 0..@matrix_size-1 # this loops for the encryption matrix column
          selected_substring = substrings[substring_idx]
          temp_ord_value += inverse_matrix[@matrix_size * row_idx + col_idx] * ((selected_substring[col_idx]).ord - 65)
        end
        @plaintext[@matrix_size * substring_idx + row_idx] = (temp_ord_value % 26 + 65).to_i.chr
      end
    end
  end

  def super_encrypt
    # Perform transposition cipher first, then extended vigenere
    # By default, the size of the column is 4
    column_size = 4
    row_size = (@plaintext.length / column_size)
    # add padding
    # if file
    if @type === 'file'
      num_of_padding = (column_size - @plaintext.length % column_size)
      substrings = Matrix.build(row_size+1, column_size) { |row, col| @plaintext[(row * column_size + col).to_s].to_i }
      for i in num_of_padding - 1..0
        substrings[row_size - 1, column_size - i] = 88
      end
      print substrings
      temptext = {}
    else
      if @plaintext.length % column_size != 0
        for i in 0..(column_size - @plaintext.length % column_size) - 1
          @plaintext += 'X'
        end
      end
      substrings = @plaintext.scan(/.{1,#{column_size}}/)
      temptext = ''
    end

    for row in 0..column_size-1
      for col in 0..row_size-1
        if @type === 'file'
          temptext[(row * (column_size - 1) + col).to_s] = substrings[row, col].to_s
        else
          temptext += substrings[col][row]
        end
      end
    end

    @plaintext = temptext
    puts @plaintext
    # extended vigenere
    self.extended_vigenere_encrypt
  end

  def super_decrypt
    # Reverse the extended vigenere first, then reverse the transposition cipher
    self.extended_vigenere_decrypt

    @ciphertext = @plaintext

    row_size = 4
    column_size = (@ciphertext.length / row_size)

    substrings = Matrix.build(row_size) { |row, col| @ciphertext[row * column_size + col] }

    temptext = []

    for col in 0..column_size-1
      for row in 0..row_size-1
        temptext.append(substrings[row, col])
      end
    end

    @plaintext = temptext

  end
end
