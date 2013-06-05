#
# * GET home page.
# 
utils = require("../utils")
models = require("../models")

#Template Rendering
exports.layout = (req, res) ->
  strng = "hello there"
  res.render "search"
exports.settings = (req, res) ->
  models.Reason (reasons, places, cities) ->
    res.render "settings",
      places: places
      cities: cities
      reasons: reasons
exports.upload = (req, res) ->
  models.Reason (reasons, places, cities) ->
    res.render "upload", 
      reasons: reasons
      places: places
      cities: cities
exports.success = (req,res) ->
	res.render "success"    
exports.view = (req,res) ->
  String.prototype.trim = -> @replace ':', '' 
  filename = req.params.id.trim()+""
  models.ViewForm filename, (forms) ->
    models.Reason (reasons, places) ->
      res.render "form",
        doc: forms
        reasons: reasons
        places: places
         
#AJAX handling
exports.modify = (req, res) ->


exports.set = (req, res) ->
  place = 
    city_id: req.body.city
    name: req.body.new_inst
  if place.name then models.AddInst(place)
  if req.body.new_city then models.AddCity(req.body.new_city)
  if req.body.new_reason then models.AddReason(req.body.new_reason)
  res.redirect "back"
exports.places = (req, res) ->
  models.Reason (reasons,places) ->
    res.send places
exports.results = (req, res) ->
  models.Search (results) ->		 
    res.send results