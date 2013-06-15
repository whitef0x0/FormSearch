
$(document).ready () ->#Bootstrap Modal init

  $('#myModal').modal
    show: false

  #Form page ajax form handling
  ###
  $("#modify").ajaxForm () ->
    @.html("Form updated successfully!")
  ###
  #Settings page ajax form handling
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

      html = template(context)
      $("#institution").html(html)
    ).trigger "change"


  # /settings prefpane event triggers
  $(".showmenu").click (e)->
    id = e.target.id
    $("#"+id+".menu").toggle "fold"
    $("#"+id+" > i.icon-chevron-right").toggleClass "icon-rotate-90" 

  #form delete ajax request handler
  $("#delFinal").click ->
    id = location.pathname.replace("/view:","")
    console.log id
    $.get '/api/delete', {id: id}
    console.log "delajax here"

  # printing form plugin event trigger
  $(".print").printPage
    attr: "href"
    message:"Preparing document for printing"

  #form downolad ajax request handler
  fireDownload = ->
    
    filename = location.pathname.replace("/view:","")
    path = "http://127.0.0.1:3001/static/"+filename+".pdf"
    window.location.assign path

  $("#download").click ->
    $.ajaxSetup beforeSend: (xhr) ->
      xhr.setRequestHeader "Content Type: application/octet-stream", "Content-Disposition: attachment; filename="+filename+".pdf"
    fireDownload()

