pg = require("pg") #native libpq bindings = `var pg = require('pg').native`
conString = "tcp://admin:password@localhost/forms"
client = new pg.Client(conString)
client.connect()

#queries are queued and executed one after another once the connection becomes available
#if client.connection._events  then client.connect()
exports.Reason = (callback) ->
  query = client.query '''SELECT r.name, r.id FROM reasons as r'''
  reasons = []
  #can stream row results back 1 at a time
  query.on "row", (row) ->
    reasons.push row

  query = client.query '''SELECT p.name, p.city_id, p.id FROM places as p'''
  places = []
  #can stream row results back 1 at a time
  query.on "row", (row) ->
    places.push row

  query = client.query '''SELECT c.c_name, c.id FROM cities as c'''
  cities = []
  #can stream row results back 1 at a time
  query.on "row", (row) ->
    cities.push row

  #fired after last row is emitted
  query.on "end", ->
    callback(reasons,places,cities)

exports.ViewForm = (name, callback) ->
  forms = []
  query = client.query """SELECT r.name AS reason, p.name AS place, c.c_name AS city, f.title, f.filename, f.is_pediatric
    FROM
    reasons as r, places as p, forms as f, cities as c
    WHERE
    f.reason_id = r.id AND f.place_id = p.id AND p.city_id = c.id AND f.filename =#{name};
    """
  
  query.on "row", (row) ->
    forms.push row
  #console.log form
  query.on "end", ->
    callback(forms)

exports.AddCity = (new_city) ->
  query = client.query """INSERT INTO cities (c_name) 
    VALUES ('#{new_city}');"""
exports.AddReason = (new_reason) ->
  query = client.query """INSERT INTO reasons (name) 
    VALUES ('#{new_reason}');"""
exports.AddInst = (new_place) ->
  query = client.query """INSERT INTO places (name, city_id) 
    VALUES ('#{new_place.name}', #{new_place.city_id});"""

exports.Upload = (new_form) ->
  query = client.query """INSERT INTO forms (title, is_pediatric, place_id, reason_id, filename) 
    VALUES ('#{new_form.title}', '#{new_form.is_ped}', #{new_form.pid}, #{new_form.rid}, 
    #{new_form.filename});
    """

exports.Search = (callback) ->
  query = client.query '''SELECT r.name, p.name, c.c_name, f.title, f.filename, f.is_pediatric
    FROM
    reasons as r, places as p, forms as f, cities as c
    WHERE
    f.reason_id = r.id AND f.place_id = p.id AND p.city_id = c.id;
    '''
  results = []
  
  #can stream row results back 1 at a time
  query.on "row", (row) ->
    results.push row

  #fired after last row is emitted
  query.on "end", ->
    callback(results)