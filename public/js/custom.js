// public/js/custom.js
function callRubyFunction() {
    console.log('Calling Ruby function');
    $.ajax({
      url: '/call_ruby_function',
      method: 'POST',
      success: function(response) {
        console.log(response);
        // Handle the response from the server
      },
      error: function(error) {
        console.error(error);
        // Handle errors
      }
    });
  }
  