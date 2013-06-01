#Config for 'results' handlebarjs template 
source_results = $("#result-template").html()
template_results = Handlebars.compile(source_results)

#Search term cleanup
String.prototype.trim = -> @replace /^\s+|\s+$/g, '' 

results = {}

#Search box ajax handling
$("#omnibox").keyup (e) ->
  key = e.keyCode || e.which
  terms = $(@).val().trim().split(" ")
  out_results = []
  score = 0
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
      console.log(result.score)
      out_results.push(result)

  out_results.sort (a,b)->
    b.score - a.score
  
  context = 
    results: out_results

  html = template_results(context)

  if (out_results+' ' == ' ' && $("#omnibox").val() != '') && terms[0].length >= 2
    $(".results").html('<br> <i> <p class = "lead"> The search term(s) "'+terms+'" did not yield any results. <br> Check your spelling and try again </p></i>')
  else
    #console.log(out_results)
    $(".results").empty() 
    $(".results").html(html)

  $.get '/api/results',(rsp)->
    results = rsp

#Handlebarjs Reasons template 


