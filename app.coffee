###
Module dependencies.
###
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
  app.use express.static(path.join(__dirname, "public"))

app.configure "development", ->
  app.use express.errorHandler()


#https = app.createServer(app).listen app.get(443), ->
 # console.log "Express SSL server listening on port " + https.get("port")

###
HTTPS Routing controls
###

app.get "/", (req, res) ->
  res.redirect "/index.html"

app.get "/api/results", (req, res)->
  models.Search (results) ->
    res.send results

app.get "/api/upload", routes.upload
#app.get "/login", routes.https_raise

http.createServer(app).listen app.get("port"),"0.0.0.0", ->
  console.log "Express server listening on port " + app.get("port")

#https.get '/login', routes.login
###
HTTP Routing controls
###
