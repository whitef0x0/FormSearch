#
# * GET home page.
# 

models = require("../models")

#Template Rendering
exports.layout = (req, res) ->
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
  name = req.params.id.trim()
  doc = {}
  models.ViewForm(name,doc) ->
    form = doc
  res.render "form",
    name: name
    form: form
       
#AJAX handling
exports.set = (req, res) ->
  console.log(req.body)
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
    console.log(results)  
    res.send results