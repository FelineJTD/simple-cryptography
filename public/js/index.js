// public/js/index.js

// ENCRYPT
function encrypt() {
  console.log('Encrypting plaintext');

  type = $('#input-type').val();
  plaintext = $('#input-text').val();
  cipher = $('#cipher').val();
  key = $('#input-key').val();
  affine_key_a = $('#input_key_a').val();
  affine_key_b = $('#input_key_b').val();
  matrix_size = $('#matrix_size').val();
  matrix = $('#matrix').val();

  // read file
  if (type == 'file') {
    var file = document.getElementById('input-file').files[0];
    if (file.type === 'text/plain') {
      var reader = new FileReader();
      reader.onload = function(e) {
        plaintext = e.target.result;
        callEncrypt({ type: type, plaintext: plaintext, cipher: cipher, key: key, affine_key_a: affine_key_a, affine_key_b: affine_key_b, matrix_size: matrix_size, matrix: matrix});
      }
      reader.readAsText(file);
    } else { // other file types, pass as array of ascii values
      console.log('File type: ' + file.type);
      var reader = new FileReader();
      reader.onload = function (e) {
        const byteArray = new Uint8Array(e.target.result);
        callEncrypt({ type: type, plaintext: byteArray, cipher: cipher, key: key, affine_key_a: affine_key_a, affine_key_b: affine_key_b, matrix_size: matrix_size, matrix: matrix});
      };

      reader.readAsArrayBuffer(file);
    }
  }
  else {
    callEncrypt({ type: type, plaintext: plaintext, cipher: cipher, key: key, affine_key_a: affine_key_a, affine_key_b: affine_key_b, matrix_size: matrix_size, matrix: matrix});
  }
}

function callEncrypt(data) {
  $.ajax({
    url: '/encrypt',
    method: 'POST',
    data: data,
    success: function(response) {
      res = JSON.parse(response);
      $('#response').val(res.result);
    },
    error: function(error) {
      console.error(error);
    }
  });
}


// DECRYPT
function decrypt() {
  console.log('Decrypting ciphertext');
  
  type = $('#input-type').val();
  ciphertext = $('#input-text').val();
  cipher = $('#cipher').val();
  key = $('#input-key').val();
  affine_key_a = $('#input_key_a').val();
  affine_key_b = $('#input_key_b').val();
  matrix_size = $('#matrix_size').val();
  matrix = $('#matrix').val();

  if (type == 'file') {
    var file = document.getElementById('input-file').files[0];
    var reader = new FileReader();
    reader.onload = function(e) {
      ciphertext = e.target.result;
      callDecrypt({ type: type, ciphertext: ciphertext, cipher: cipher, key: key, affine_key_a: affine_key_a, affine_key_b: affine_key_b, matrix_size: matrix_size, matrix: matrix});
    }
    reader.readAsText(file);
  }
  else {
    callDecrypt({ type: type, ciphertext: ciphertext, cipher: cipher, key: key, affine_key_a: affine_key_a, affine_key_b: affine_key_b, matrix_size: matrix_size, matrix: matrix});
  }
}

function callDecrypt(data) {
  $.ajax({
    url: '/decrypt',
    method: 'POST',
    data: data,
    success: function(response) {
      res = JSON.parse(response);
      console.log(res);
      $('#response').val(res.result);
      $('#response-64').val(btoa(res.result));
    },
    error: function(error) {
      console.error(error);
    }
  });
}

function convertToASCIIArray(content) {
  const asciiArray = [];
  for (let i = 0; i < content.length; i++) {
    asciiArray.push(content.charCodeAt(i));
  }
  return asciiArray;
}

// LISTENERS
// on change of #input-text, update #input-text-64 to display base64 encoded text
$('#input-text').on('input', function() {
  $('#input-text-64').val(btoa($('#input-text').val()));
});