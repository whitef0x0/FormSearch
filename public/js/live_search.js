$(function() {
  $('#results').hide();

  function getResults()
  {
    var title = $('#results').text();
    var msg, cnt, obj = new Array();
    $.getJSON('/results/', function(data) {
      
      for (var i = 0; i < Object.keys(data).length; i++) {
        obj.push(data[i]);
        console.log(obj[i].title);
        
        $("<li class = 'unstyled'>").appendTo('#results').text(obj[i].title);
        $("#results").append("    Location: "+obj[i].location+"   Type: "+obj[i].type+"   Institution: "+obj[i].place);
      } 
      
      
    });



    $('#results').show();
    return false;
  }

  var count = 0;
  $('#omnibox').keyup(function (e) {
    //console.log("checking for keypress");
    //console.log( $('#omnibox').val());
    if(e.which != 32 && count == 0) {
        getResults();
        count = 1;      
    }

    else if ($('#omnibox').val() == ''){
      $('#results').hide()
      count = 0;
    }
    
  });
  
});