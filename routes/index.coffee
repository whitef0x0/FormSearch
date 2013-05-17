#
# * GET home page.
# 

models = require("../models")


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



exports.login = (req, res) ->
  res.render "/partials/login",
    searchbox: 'true'
#    res.send(JSON.stringify(templates.login))
###

exports.results = (req, res) ->	

  res.contentType "json" 
  models.Search req.query.term, (data) ->		  
    console.log "DATA OUTPUT IS:"
    #console.log data
    res.json(data)

exports.upload = (req, res) ->
  res.render
    res.contentType "json"

    ###
    res.send(
      '<form action="/upload" enctype="multipart/form-data" method="post">'+
      '<input type="text" name="title"><br>'+
      '<input type="file" name="upload" multiple="multiple"><br>'+
      '<input type="submit" value="Upload">'+
      '</form>')
    ###
