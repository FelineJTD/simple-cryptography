// public/js/index.js

function encrypt() {
  console.log('Encrypting plaintext');
  plaintext = $('#input-text').val();
  cipher = $('#cipher').val();
  key = $('#input-key').val();
  $.ajax({
    url: '/encrypt',
    method: 'POST',
    data: { plaintext: plaintext, cipher: cipher, key: key },
    success: function(response) {
      console.log("success");
      console.log(response);
      // Handle the response from the server
      // display response in a div with id "response"
      $('#response').html(response);
    },
    error: function(error) {
      console.error("error");
      console.error(error);
      // Handle errors
    }
  });
}