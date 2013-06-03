// Generated by CoffeeScript 1.3.3
(function() {
  var models;

  models = require("../models");

  exports.layout = function(req, res) {
    return res.render("search");
  };

  exports.settings = function(req, res) {
    return models.Reason(function(reasons, places, cities) {
      return res.render("settings", {
        places: places,
        cities: cities,
        reasons: reasons
      });
    });
  };

  exports.upload = function(req, res) {
    return models.Reason(function(reasons, places, cities) {
      return res.render("upload", {
        reasons: reasons,
        places: places,
        cities: cities
      });
    });
  };

  exports.success = function(req, res) {
    return res.render("success");
  };

  exports.view = function(req, res) {
    var doc, name;
    String.prototype.trim = function() {
      return this.replace(':', '');
    };
    name = req.params.id.trim();
    doc = {};
    models.ViewForm(name, doc)(function() {
      var form;
      return form = doc;
    });
    return res.render("form", {
      name: name,
      form: form
    });
  };

  exports.set = function(req, res) {
    var place;
    console.log(req.body);
    place = {
      city_id: req.body.city,
      name: req.body.new_inst
    };
    if (place.name) {
      models.AddInst(place);
    }
    if (req.body.new_city) {
      models.AddCity(req.body.new_city);
    }
    if (req.body.new_reason) {
      models.AddReason(req.body.new_reason);
    }
    return res.redirect("back");
  };

  exports.places = function(req, res) {
    return models.Reason(function(reasons, places) {
      return res.send(places);
    });
  };

  exports.results = function(req, res) {
    return models.Search(function(results) {
      console.log(results);
      return res.send(results);
    });
  };

}).call(this);
