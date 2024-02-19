// public/js/index.js
function callRubyFunction() {
  console.log('Calling Ruby function');
  $.ajax({
    url: '/call_ruby_function',
    method: 'GET',
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

function encrypt() {
  console.log('Encrypting plaintext');
  plaintext = $('#plaintext').val();
  cipher = $('#cipher').val();
  $.ajax({
    url: '/encrypt',
    method: 'POST',
    data: { plaintext: plaintext, cipher: cipher },
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