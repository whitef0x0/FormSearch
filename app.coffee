#Module dependencies.
models = require("./models")
express = require("express")
routes = require("./routes")
http = require("http")
path = require("path")
https = require("https")      # module for https
fs =    require("fs")         # required to read certs and keys
###
  opts = {
      key:    fs.readFileSync("ssl/funkmod.key"),
      cert:   fs.readFileSync("ssl/funkmod.crt"),
      ca:     fs.readFileSync("ssl/funkmod.crt"),
      requestCert:        true,
      rejectUnauthorized: true,
      passphrase: "password"
  }
###
app = express()

app.configure ->
  app.set "port", process.env.PORT or 3001
  app.use express.favicon()
  app.use express.logger("dev")
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use "view engine", "jade"
  app.use express.static(path.join(__dirname, "public"))

app.configure "development", ->
  app.use express.errorHandler()


# https = app.createServer(app).listen app.get(443), ->
# console.log "Express SSL server listening on port " + https.get("port")

###
  HTTPS Routing controls
###

app.get "/", (req, res) ->
  res.redirect "/index.html"

app.get "/api/results", (req, res)->
  models.Search (results) ->
    res.send results


app.get "/api/upload", (req, res)->
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

app.get "/upload", (req, res)->  

  res.send '<form action="/api/upload" enctype="multipart/form-data" method="post"><input type="text" name="institution"><input type="drop" name="city"><input type="text" name="title"><br><input type="file" name="upload" multiple="multiple"><br><input(type="file", name="displayForm")/><br><input type="submit" value="Upload"></form>'

http.createServer(app).listen app.get("port"),"0.0.0.0", ->
  console.log "Express server listening on port " + app.get("port")


