// Generated by CoffeeScript 1.6.3
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
    app.set('view options', {
      layout: false
    });
    app.use(express.favicon());
    app.use(express.logger("dev"));
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(app.router);
    app.use(express["static"](path.join(__dirname, "public")));
    return app.use('/static', express["static"](__dirname + "/static"));
  });

  app.configure("development", function() {
    return app.use(express.errorHandler());
  });

  /*
    HTTPS Routing controls
  */


  app.get("/", routes.layout);

  app.get("/upload", routes.upload);

  app.get("/success", routes.success);

  app.get("/settings", routes.settings);

  app.get("/view:id", routes.view);

  app.get("/api/delete", routes["delete"]);

  app.get("/api/results", routes.results);

  app.get("/api/places", routes.places);

  app.post("/api/update", routes.update);

  app.post("/api/settings", routes.set);

  app.post("/api/upload", function(req, res) {
    var form, hash, string;
    string = req.body.title + "";
    hash = string.hashCode();
    form = {
      title: req.body.title,
      pid: req.body.institution,
      rid: req.body.reason,
      is_ped: '',
      filename: hash
    };
    console.log(form.filename);
    if (req.body.ped_t) {
      form.is_ped = 't';
    } else if (req.body.ped_f) {
      form.is_ped = 'f';
    }
    return fs.readFile(req.files.displayForm.path, function(err, data) {
      var newPath;
      newPath = __dirname + "/static/" + hash + ".pdf";
      return fs.writeFile(newPath, data, function(err) {
        models.Upload(form);
        return res.redirect("success");
      });
    });
  });

  http.createServer(app).listen(app.get("port"), "0.0.0.0", function() {
    return console.log("Express server listening on port " + app.get("port"));
  });

}).call(this);
