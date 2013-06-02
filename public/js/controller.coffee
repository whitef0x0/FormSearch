if $("#template").length != 0 
      
  #Config for handlebar.js template
  source = $("#template").html()
  template = Handlebars.compile(source)
  #Search term cleanup
  String.prototype.trim = -> @replace /^\s+|\s+$/g, '' 
  results = {}
  places = {}
  $.get '/api/places', (rsp) ->
    places = rsp

  #/upload templating
  $("#city").change( -> 
    #Get id (option value) of the currently selected city
    curr_id = $("#city").find(":selected").val()

    out_places = []

    for place in places
      if place.city_id+'' == curr_id
        out_places.push(place)
   
    context =
      places: out_places

    console.log(places)

    html = template(context)
    $("#institution").html(html)
  ).trigger "change"

  #/api/results event handler and filtering
  $("#omnibox").keyup (e) ->
    key = e.keyCode || e.which

    terms = $(@).val().trim().split(" ")
    out_results = []

    for result in results
      result.score = 0
      for term in terms
        continue unless term
        term = term.toLowerCase()
        if result.name.toLowerCase().indexOf(term) > -1 
          result.score += 1
        if result.c_name.toLowerCase().indexOf(term) > -1 
          result.score += 1
        if result.title.toLowerCase().indexOf(term) > -1 
          result.score += 1

      if result.score > 0

        out_results.push(result)

    out_results.sort (a,b)->
      b.score - a.score
    
    context = 
      results: out_results
    html = template(context)

    if (out_results+' ' == ' ' && $("#omnibox").val() != '') && !terms[0] >=1
      $(".results").show()
      $(".results").css("background-color", "white")
      $(".results").html('<br> <i> <p class = "lead"> The search term(s) "'+terms+'" did not yield any results. <br> Check your spelling and try again </p></i>')
    else if terms[0].length <=1
      $(".results").hide()
      $("#omnibox").switchClass("small", "large", 100)
    else
      $("#omnibox").switchClass("large", "small", 80)
      $(".results").show()
      $(".results").css("background-color","B1DCFE");
      $(".results").html(html)

    $.get '/api/results', (rsp)->
      results = rsp

# /settings prefpane event triggers
$("div.show.btn").click (e)->
  id = e.target.id
  $("#"+id+".menu").toggle "fold"

#
$(".print").printPage(
  message:"Preparing document for printing"
  )
