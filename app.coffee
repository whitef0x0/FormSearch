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
  app.use express.favicon()
  app.use express.logger("dev")
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(path.join(__dirname, "public"))
  app.use express.static(__dirname + "/upload")
app.configure "development", ->
  app.use express.errorHandler()
###
  HTTPS Routing controls
###
console.log(routes.layout)

app.get "/", routes.layout
app.get "/upload", routes.upload 
app.get "/api/results", routes.results

app.post "/api/upload", (req, res)->

  form =
    title: req.body.title
    location: req.body.city
    name: req.body.institution
    reason: req.body.diagnosis
  if req.body.ped_t
    form.is_ped = 't'
  else req.body.ped_f
    form.is_ped = 'f' 
  console.log form.title+" |"+form.is_ped
  models.Upload (form) ->
    
  ###
  fs.readFile req.files.displayForm.path, (err, data) ->
    newPath = __dirname + "/uploads/"

    form.name = newPath #.replace "/uploads/",""
    form.title = req.body.title
    form.is_ped = req.body.city
    form.location.city = req.body.city
    form.location.name = req.body.institution
    form.reason = req.body.diagnosis

    fs.writeFile newPath, data, (err) ->
      models.Upload(form) ->
        res.redirect "back"
  ###

http.createServer(app).listen app.get("port"),"0.0.0.0", ->
  console.log "Express server listening on port " + app.get("port")


