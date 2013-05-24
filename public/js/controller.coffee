source   = $("#entry-template").html()
template = Handlebars.compile(source)

String.prototype.trim = -> @replace /^\s+|\s+$/g, '' 

results = {}

$("#upload").click ->
 
  $.get "/upload", (data) ->
    console.log("got here") 
    $("#search").hide()
    console.log(data)
    $(".container").html(data)
    

$("#omnibox").keyup ->
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

  console.log context.results

  html = template(context)
  $(".results").html(html)


$.get '/api/results', (rsp)->

  results = rsp
