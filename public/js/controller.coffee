#Config for handlebar.js template

source = $("#template").html()
template = Handlebars.compile(source)
#Search term cleanup
String.prototype.trim = -> @replace /^\s+|\s+$/g, '' 
results = {}
places = {}
$.get '/api/places', (rsp) ->
  places = rsp

$("#city").change( -> 
  #Get the currently selected city
  curr_city = $("#city").find(":selected").text()
  out_places = []

  for place in places
    if place.city == curr_city
      out_places.push(place)
 
  context =
    places: out_places

  html = template(context)
  $("#institution").html(html)
).trigger "change"

#Search results event handler and filtering
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
      if result.city.toLowerCase().indexOf(term) > -1 
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

  if (out_results+' ' == ' ' && $("#omnibox").val() != '') && terms[0].length >= 2
    $(".results").html('<br> <i> <p class = "lead"> The search term(s) "'+terms+'" did not yield any results. <br> Check your spelling and try again </p></i>')
  else
    $(".results").html(html)

  $.get '/api/results', (rsp)->
    console.log(rsp)
    results = rsp
