source   = $("#entry-template").html()
template = Handlebars.compile(source)

context = 
  results: [
  ]

$.get '/api/results', (results)->
  console.log results

html = template(context)
$(".results").html(html)