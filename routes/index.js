// Generated by CoffeeScript 1.6.3
(function() {
  var fs, models, path, utils;

  path = require("path");

  utils = require("../utils");

  models = require("../models");

  fs = require("fs");

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
    var filename;
    String.prototype.trim = function() {
      return this.replace(':', '');
    };
    filename = req.params.id.trim() + "";
    return models.ViewForm(filename, function(forms) {
      return models.Reason(function(reasons, places) {
        return res.render("form", {
          doc: forms,
          reasons: reasons,
          places: places
        });
      });
    });
  };

  exports.update = function(req, res) {
    var form;
    console.log(req.body);
    form = {
      inst: req.body.inst,
      place: req.body.place,
      reason: req.body.reason,
      title: req.body.title
    };
    if (req.body.ped_t) {
      form.is_ped = 't';
    } else if (req.body.ped_f) {
      form.is_ped = 'f';
    }
    return models.UpdateForm(form);
  };

  exports["delete"] = function(req, res) {
    var dirname, filename;
    filename = req.query.id + "";
    path = '/static/' + filename + '.pdf';
    dirname = __dirname.replace("/routes", "");
    fs.unlinkSync(dirname + path)(function(err) {
      if (err) {
        throw err;
      }
      return models.DelForm(filename);
    });
    return res.redirect("search");
  };

  exports.set = function(req, res) {
    var place;
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
      return res.send(results);
    });
  };

}).call(this);
