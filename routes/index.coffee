#
# * GET home page.
utils = require("../utils")
models = require("../models")
fs = require("fs")
path = require 'path'

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
  models.Form.view filename, (forms) ->
    models.Reason (reasons, places) ->
      res.render "form",
        doc: forms
        reasons: reasons
        places: places

#AJAX handling 
exports.view_upload = (req,res) ->
  string = req.body.title+"" 
  slug = utils.slugify(string)
  form =
    title: req.body.title
    pid: req.body.institution
    rid: req.body.reason
    is_ped: ''
    filename: slug
  if req.body.ped_t
    form.is_ped = 't'
  else if req.body.ped_f
    form.is_ped = 'f' 
  console.log "#{slug}"
  fs.readFile req.files.displayForm.path, (err, data) ->
    newPath = __dirname + "/../static/#{slug}.pdf"

    fs.writeFile newPath, data, (err) ->
      console.log err
  models.Form.add (form) 
  console.log form
  res.redirect "success"

exports.update = (req, res) ->


exports.delete = (req,res) ->
  if req.params.type is 'form'
    filename = req.query.id+""
    location = path.join __dirname, '../static/', filename+'.pdf'

    fs.unlink location, (err) ->
      throw err if err
      models.Form.del(filename)
      res.redirect "/"
  else if req.params.type is 'city'
    models.City.del(req.query.id)
    res.redirect "/"

exports.set = (req, res) ->
  place = 
    city_id: req.body.city
    name: req.body.new_inst
  if place.name then models.AddInst(place)
  if req.body.new_city then models.City.add(req.body.new_city)
  if req.body.new_reason then models.AddReason(req.body.new_reason)
  res.redirect "back"

exports.places = (req, res) ->
  models.Reason (reasons,places) ->
    res.send places

exports.results = (req, res) ->
  models.Search (results) ->		 
    res.send results