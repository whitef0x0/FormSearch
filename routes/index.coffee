#
# * GET home page.
# 

models = require("../models")

exports.layout = (req, res) ->
  res.render "search"
exports.places = (req, res) ->
  models.Reason (reasons,places) ->
    res.send places
exports.results = (req, res) ->	
  models.Search (results) ->		  
    res.send results
exports.upload = (req, res) ->
  models.Reason (reasons, places) ->
    res.render "upload", 
      reasons: reasons
      places: places
    


