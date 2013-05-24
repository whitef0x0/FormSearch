pg = require("pg") #native libpq bindings = `var pg = require('pg').native`
conString = "tcp://admin:halflife2@localhost/postgres"
client = new pg.Client(conString)
client.connect()

#queries are queued and executed one after another once the connection becomes available
#if client.connection._events  then client.connect()
exports.Upload = (callback) ->
  query = client.query '''with rows as(INSERT INTO reasons (name) VALUES ({#file.reason}) RETURNING pid AND
    INSERT INTO places (name, city) VALUES ({#file.location.name}, {#file.location.city}) RETURNING rid);
    INSERT INTO forms (title, is_pediatric, reason_id, place_id) VALUES ({#file.title},{#file.is_ped}, rid, pid);
     '''

exports.Search = (callback) ->
  
  query = client.query '''SELECT r.name, p.name, p.city, f.title FROM
    reasons as r, places as p, forms as f
    WHERE
    f.reason_id = r.id AND f.place_id = p.id
    '''
  results = []
  
  #can stream row results back 1 at a time
  query.on "row", (row) ->
    results.push row
    console.log results


  #fired after last row is emitted
  query.on "end", ->
    callback(results)
    client.end()
  

