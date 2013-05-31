(function() {
  var app, express, fs, http, https, models, path, routes;

  models = require("./models");

  express = require("express");

  routes = require("./routes");

  http = require("http");

  path = require("path");

  https = require("https");

  fs = require("fs");

  app = express();

  app.configure(function() {
    app.set("port", process.env.PORT || 3001);
    app.set("views", __dirname + "/views");
    app.set("view engine", "jade");
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

  console.log(routes.layout);

  app.get("/", routes.layout);

  app.get("/upload", routes.upload);

  app.get("/api/results", routes.results);

  app.get("/api/upload", function(req, res) {
    return fs.readFile(req.files.displayForm.path, function(err, data) {
      var newPath;
      newPath = __dirname + "/uploads/";
      form.name = newPath;
      form.title = req.body.title;
      form.is_ped = req.body.city;
      form.location.city = req.body.city;
      form.location.name = req.body.institution;
      form.reason = req.body.diagnosis;
      return fs.writeFile(newPath, data, function(err) {
        return models.Upload(form)(function() {
          return res.redirect("back");
        });
      });
    });
  });

  http.createServer(app).listen(app.get("port"), "0.0.0.0", function() {
    return console.log("Express server listening on port " + app.get("port"));
  });

}).call(this);
