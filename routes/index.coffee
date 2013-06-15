#
# * GET home page.
# 
path = require("path")
utils = require("../utils")
models = require("../models")
fs = require("fs")
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
  filename = req.params.id.trim()+""
  models.ViewForm filename, (forms) ->
    models.Reason (reasons, places) ->
      res.render "form",
        doc: forms
        reasons: reasons
        places: places
         
#AJAX handling

exports.update = (req,res) ->
  console.log req.body

  form =
    inst: req.body.inst
    place: req.body.place
    reason: req.body.reason
    title: req.body.title
  if req.body.ped_t
    form.is_ped = 't'
  else if req.body.ped_f
    form.is_ped = 'f' 
  models.UpdateForm(form)

exports.delete = (req,res) ->
  filename = req.query.id+""
  path = '/static/'+filename+'.pdf'
  dirname = __dirname.replace "/routes", "" 

  fs.unlinkSync(dirname+path) (err) ->
    throw err if err
    models.DelForm(filename)
  res.redirect "search"

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