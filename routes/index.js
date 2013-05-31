(function() {
  var models;

  models = require("../models");

  /*
    templates =
      "login": 
        "inputs": [
          {
            "label": "Password", 
            "name": "Password", 
            "id": "password", 
            "type": "text"
          },
          {
            "label": "Username", 
            "name": "Username", 
            "id": "username", 
            "type": "text"
          }
        ]
     
      "signup": 
        "inputs": [
          {
            "name": "Password", 
            "id": "password", 
            "type": "text"
          },
          {
            "name": "Username", 
            "id": "username", 
            "type": "text"
          },
          {
            "name": "Email", 
            "id": "email", 
            "type": "text"
          },
          {
            "name": "ToS", 
            "id": "tos", 
            "type": "checkbox"
          }
        ]
  
    exports.Login = (req, res) ->
      res.render "/login",
  */

  exports.layout = function(req, res) {
    return res.render("search");
  };

  exports.results = function(req, res) {
    return models.Search(function(results) {
      return res.send(results);
    });
  };

  exports.upload = function(req, res) {
    return res.render("upload");
  };

}).call(this);
