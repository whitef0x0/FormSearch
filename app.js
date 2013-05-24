(function() {
  var app, express, fs, http, https, models, path, routes;

  models = require("./models");

  express = require("express");

  routes = require("./routes");

  http = require("http");

  path = require("path");

  https = require("https");

  fs = require("fs");

  /*
    opts = {
        key:    fs.readFileSync("ssl/funkmod.key"),
        cert:   fs.readFileSync("ssl/funkmod.crt"),
        ca:     fs.readFileSync("ssl/funkmod.crt"),
        requestCert:        true,
        rejectUnauthorized: true,
        passphrase: "password"
    }
  */

  app = express();

  app.configure(function() {
    app.set("port", process.env.PORT || 3001);
    app.use(express.favicon());
    app.use(express.logger("dev"));
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(app.router);
    return app.use(express.static(path.join(__dirname, "public")));
  });

  app.configure("development", function() {
    return app.use(express.errorHandler());
  });

  /*
    HTTPS Routing controls
  */

  app.get("/", function(req, res) {
    return res.redirect("/index.html");
  });

  app.get("/api/results", function(req, res) {
    return models.Search(function(results) {
      return res.send(results);
    });
  });

  app.get("/api/upload", function(req, res) {
    fs.readFile(req.files.displayForm.path, function(err, data) {
      var newPath;
      return newPath = __dirname + "/uploads/";
    });
    form.name = newPath;
    return fs.writeFile(newPath, data, function(err) {
      return models.Upload(form.name)(function() {
        return res.redirect("back");
      });
    });
  });

  app.get("/upload", function(req, res) {
    return res.render("/upload", res.contentType("json"), res.send('<form action="/api/upload" enctype="multipart/form-data" method="post">' + '<input type="text" name="title"><br>' + '<input type="file" name="upload" multiple="multiple"><br>' + '<input(type="file", name="displayForm")/><br>' + '<input type="submit" value="Upload">' + '</form>'));
  });

  http.createServer(app).listen(app.get("port"), "0.0.0.0", function() {
    return console.log("Express server listening on port " + app.get("port"));
  });

}).call(this);
