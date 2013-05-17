pg = require("pg") #native libpq bindings = `var pg = require('pg').native`
conString = "tcp://admin:halflife2@localhost/forms"
client = new pg.Client(conString)
client.connect()

#queries are queued and executed one after another once the connection becomes available



exports.Search = (term, callback) ->
  ##if client.connection._events  then client.connect()
  query = client.query """SELECT r.name, t.name, p.name, p.city, f.title FROM reasons as r, types as t, places as p, forms as f"""
  ###  
  r.name, t.name, p.name, p.city, f.title
  FROM
  reasons as r, types as t, places as p, forms as f
  WHERE
  f.reason_id = r.id AND f.place_id = p.id AND f.service_id = s.id
  AND (
    r.name ILIKE '%#{term}%'
    OR t.name ILIKE '%#{term}%'
    OR p.name ILIKE '%#{term}%'
    OR p.city ILIKE '%#{term}%'
    OR f.title ILIKE '%#{term}%'
  )
  """
  ###
  results = []
  
  #can stream row results back 1 at a time
  query.on "row", (row) ->
    results.push row
    console.log results


  #fired after last row is emitted
  query.on "end", ->
    callback(results)
    #client.end()
  

