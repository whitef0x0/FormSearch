pg = require("pg") #native libpq bindings = `var pg = require('pg').native`
conString = "tcp://admin:password@localhost/forms"
client = new pg.Client(conString)
client.connect()

#queries are queued and executed one after another once the connection becomes available
#if client.connection._events  then client.connect()
exports.Reason = (callback) ->

  query = client.query '''SELECT r.name, r.rid FROM reasons as r'''
  reasons = []
  #can stream row results back 1 at a time
  query.on "row", (row) ->
    reasons.push row

  query = client.query '''SELECT p.name, p.city, p.pid FROM places as p'''
  places = []
  #can stream row results back 1 at a time
  query.on "row", (row) ->
    places.push row

  #fired after last row is emitted
  query.on "end", ->
    callback(reasons,places)

exports.Upload = (form) ->
  
  query = client.query """INSERT INTO forms (title, is_pediatric, place_id, reason_id) 
    VALUES ('#{form.title}', '#{form.is_ped}', '#{form.pid}', '#{form.rid}');"""
 
  query.on "end", ->
exports.Search = (callback) ->
  
  query = client.query '''SELECT r.name, p.name, p.city, f.title, f.filename, f.is_pediatric
    FROM
    reasons as r, places as p, forms as f
    WHERE
    f.reason_id = r.rid AND f.place_id = p.pid
    '''
  results = []
  
  #can stream row results back 1 at a time
  query.on "row", (row) ->
    results.push row
    console.log results


  #fired after last row is emitted
  query.on "end", ->
    callback(results)

  

