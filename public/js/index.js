// public/js/index.js

// ENCRYPT
function encrypt() {
  console.log('Encrypting plaintext');

  type = $('#input-type').val();
  plaintext = $('#input-text').val();
  cipher = $('#cipher').val();
  key = $('#input-key').val();

  // read file
  if (type == 'file') {
    var file = document.getElementById('input-file').files[0];
    var reader = new FileReader();
    reader.onload = function(e) {
      plaintext = e.target.result;
      callEncrypt({ type: type, plaintext: plaintext, cipher: cipher, key: key });
    }
    reader.readAsText(file);
  }
  else {
    callEncrypt({ type: type, plaintext: plaintext, cipher: cipher, key: key });
  }
}

function callEncrypt(data) {
  $.ajax({
    url: '/encrypt',
    method: 'POST',
    data: data,
    success: function(response) {
      $('#response').val(response);
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

  if (type == 'file') {
    var file = document.getElementById('input-file').files[0];
    var reader = new FileReader();
    reader.onload = function(e) {
      ciphertext = e.target.result;
      callDecrypt({ type: type, ciphertext: ciphertext, cipher: cipher, key: key });
    }
    reader.readAsText(file);
  }
  else {
    callDecrypt({ type: type, ciphertext: ciphertext, cipher: cipher, key: key });
  }
}

function callDecrypt(data) {
  $.ajax({
    url: '/decrypt',
    method: 'POST',
    data: data,
    success: function(response) {
      $('#response').html(response.result);
    },
    error: function(error) {
      console.error(error);
    }
  });
}


// LISTENERS
// on change of #input-text, update #input-text-64 to display base64 encoded text
$('#input-text').on('input', function() {
  $('#input-text-64').val(btoa($('#input-text').val()));
});

// on change of #input-text-64, update #input-text to display base64 decoded text
$('#input-text-64').on('change', function() {
  $('#input-text').val(atob($('#input-text-64').val()));
});