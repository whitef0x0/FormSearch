
# Setup templates if they exist.
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



# /settings prefpane event triggers
$(".showmenu").click (e)->
  id = e.target.id
  $("#"+id+".menu").toggle "fold"
  $("#"+id+" > i.icon-chevron-right").toggleClass "icon-rotate-90" 

#
$(".print").printPage(
  attr: "href"
  message:"Preparing document for printing"
  )
