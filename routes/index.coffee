#
# * GET home page.
# 

models = require("../models")
###
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
###
exports.layout = (req, res) ->
  res.render "search"
exports.results = (req, res) ->	
  models.Search (results) ->		  
    res.send results
exports.upload = (req, res) ->
  res.render "upload"
