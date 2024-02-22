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
  if (type == 'file' && (cipher == 'extended' || cipher == 'super')) {
    const fileExtension = $('#input-file').val().split('.').pop();
    var file = document.getElementById('input-file').files[0];
    var reader = new FileReader();
    reader.onload = function (e) {
      const byteArray = new Uint8Array(e.target.result);
      callEncrypt({ type: type, file_extension: fileExtension, plaintext: byteArray, cipher: cipher, key: key, affine_key_a: affine_key_a, affine_key_b: affine_key_b, matrix_size: matrix_size, matrix: matrix});
    };
    reader.readAsArrayBuffer(file);
  } else if (type == 'file') {
    const fileExtension = $('#input-file').val().split('.').pop();
    var file = document.getElementById('input-file').files[0];
    var reader = new FileReader();
    reader.onload = function(e) {
      plaintext = e.target.result;
      callEncrypt({ type: type, file_extension: fileExtension, plaintext: plaintext, cipher: cipher, key: key, affine_key_a: affine_key_a, affine_key_b: affine_key_b, matrix_size: matrix_size, matrix: matrix});
    }
    reader.readAsText(file);
  }
  else {
    callEncrypt({ type: type, file_extension: '', plaintext: plaintext, cipher: cipher, key: key, affine_key_a: affine_key_a, affine_key_b: affine_key_b, matrix_size: matrix_size, matrix: matrix});
  }
}

function callEncrypt(data) {
  $.ajax({
    url: '/encrypt',
    method: 'POST',
    data: data,
    success: function(response) {
      if (document.getElementById('download-link')) {
        document.getElementById('download-link').remove();
      }
      res = JSON.parse(response);
      $('#response').val(res.result);
      $('#response-64').val(btoa(res.result));
      if (data.type == 'file' || data.cipher == 'extended' || data.cipher == 'super') {
        // download file
        var blob;
        if (data.cipher == 'extended' || data.cipher == 'super') {
          const reconstructed = new Uint8Array(res.result);
          // try to display in #response
          const str = String.fromCharCode.apply(null, reconstructed);
          $('#response').val(str);
          blob = new Blob([reconstructed], { type: 'application/octet-stream' });
        } else {
          blob = new Blob([res.result], { type: 'application/octet-stream' });
        }
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = `encrypted.${data.file_extension || 'txt'}`;
        a.id = 'download-link';
        document.body.appendChild(a);
        a.click();
      }
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

  // read file
  if (type === 'file' && (cipher === 'extended' || cipher === 'super')) {
    const fileExtension = $('#input-file').val().split('.').pop();
    var file = document.getElementById('input-file').files[0];
    var reader = new FileReader();
    reader.onload = function (e) {
      const byteArray = new Uint8Array(e.target.result);
      callDecrypt({ type: type, file_extension: fileExtension, ciphertext: byteArray, cipher: cipher, key: key, affine_key_a: affine_key_a, affine_key_b: affine_key_b, matrix_size: matrix_size, matrix: matrix});
    };
    reader.readAsArrayBuffer(file);
  } else if (type === 'file') {
    const fileExtension = $('#input-file').val().split('.').pop();
    var file = document.getElementById('input-file').files[0];
    var reader = new FileReader();
    reader.onload = function (e) {
      const ciphertext = e.target.result;
      callDecrypt({ type: type, file_extension: fileExtension, ciphertext: ciphertext, cipher: cipher, key: key, affine_key_a: affine_key_a, affine_key_b: affine_key_b, matrix_size: matrix_size, matrix: matrix});
    };
    reader.readAsText(file);
  } else {
    callDecrypt({ type: type, ciphertext: ciphertext, cipher: cipher, key: key, affine_key_a: affine_key_a, affine_key_b: affine_key_b, matrix_size: matrix_size, matrix: matrix});
  }
}

function callDecrypt(data) {
  $.ajax({
    url: '/decrypt',
    method: 'POST',
    data: data,
    success: function(response) {
      if (document.getElementById('download-link')) {
        document.getElementById('download-link').remove();
      }
      res = JSON.parse(response);
      console.log(res);
      $('#response').val(res.result);
      $('#response-64').val(btoa(res.result));
      if (data.type == 'file' || data.cipher == 'extended' || data.cipher == 'super') {
        // download file
        var blob;
        if (data.cipher == 'extended' || data.cipher == 'super') {
          const reconstructed = new Uint8Array(res.result);
          // try to display in #response
          const str = String.fromCharCode.apply(null, reconstructed);
          $('#response').val(str);
          blob = new Blob([reconstructed], { type: 'application/octet-stream' });
        } else {
          blob = new Blob([res.result], { type: 'application/octet-stream' });
        }
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = `decrypted.${data.file_extension || 'txt'}`;
        a.id = 'download-link';
        document.body.appendChild(a);
        a.click();
      }
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

function download() {
  if (document.getElementById('download-link')) {
    document.getElementById('download-link').click();
  } else {
    console.log($('#response').val());
    const blob = new Blob([$('#response').val()], { type: 'text/plain' });
    const url = URL.createObjectURL(blob);
    if (document.getElementById('download-link')) {
      document.getElementById('download-link').remove();
    }
    const a = document.createElement('a');
    a.href = url;
    a.download = `result.txt`;
    a.id = 'download-link';
    document.body.appendChild(a);
    a.click();
  }
}

// LISTENERS
// on change of #input-text, update #input-text-64 to display base64 encoded text
$('#input-text').on('input', function() {
  $('#input-text-64').val(btoa($('#input-text').val()));
});