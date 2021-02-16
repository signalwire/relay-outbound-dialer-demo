// setting up Faye
Faye.logger = window.console

var faye_client = new Faye.Client( 'http://localhost:9292/faye' );

faye_client.subscribe( '/updates', function( data ) {
  var msg = document.createElement("div");
  msg.innerText = data.event
  msg.className = "msg";
  document.getElementById('messages').prepend(msg)
});

function ready(callback) {
  if (document.readyState != 'loading') {
    callback();
  } else if (document.addEventListener) {
    document.addEventListener('DOMContentLoaded', callback);
  } else {
    document.attachEvent('onreadystatechange', function() {
      if (document.readyState != 'loading') {
        callback();
      }
    });
  }
}

function startCalls(e) {
  formSubmit('/start', {numbers: document.getElementById('numbers').value})
}

function formSubmit(url, body) {
  var formData = new FormData();
  for (const [key, value] of Object.entries(body)) {
    formData.append(key, value)
  }

  fetch(url, {
    body: formData,
    method: "post"
  })
  return false;
}

ready(async function() {
  document.getElementById('startCalls').onclick = function(e) {
    startCalls();
  }
});