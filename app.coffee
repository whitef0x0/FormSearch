#Module dependencies.
models = require("./models")
express = require("express")
routes = require("./routes")
http = require("http")
path = require("path")
https = require("https")      # module for https
fs =    require("fs")         # required to read certs and keys

app = express()

app.configure ->
  app.set "port", process.env.PORT or 3001
  app.set "views", __dirname + "/views"
  app.set "view engine", "jade" 
  app.set 'view options',{layout:false}
  app.use express.favicon()
  app.use express.logger("dev")
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(path.join(__dirname, "public"))
  app.use '/static', express.static(__dirname + "/static")
app.configure "development", ->
  app.use express.errorHandler()
###
  HTTPS Routing controls
###
console.log(routes.layout)

app.get "/", routes.layout
app.get "/upload", routes.upload 
app.get "/success", routes.success
app.get "/settings", routes.settings
app.get "/view:id", routes.view

app.post "/api/settings", routes.set
app.get "/api/results", routes.results
app.get "/api/places", routes.places
app.post "/api/upload", (req, res)->
  console.log(req.body)
  form =
    filename: ''
    title: req.body.title
    pid: req.body.city
    inst: req.body.institution
    rid: req.body.reason
    is_ped: ''
 
  if req.body.ped_t
    form.is_ped = 't'
  else if req.body.ped_f
    form.is_ped = 'f' 
  
  fs.readFile req.files.displayForm.path, (err, data) ->
    form.filename = newPath = __dirname + "/static/"+req.body.title+".pdf"
    console.log(newPath)

    fs.writeFile newPath, data, (err) ->
      models.Upload (form) 
      res.redirect "success"
  
http.createServer(app).listen app.get("port"),"0.0.0.0", ->
  console.log "Express server listening on port " + app.get("port")


