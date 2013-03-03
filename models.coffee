pg = require("pg") #native libpq bindings = `var pg = require('pg').native`
conString = "tcp://postgres@localhost/forms"
client = new pg.Client(conString)
client.connect()

#queries are queued and executed one after another once the connection becomes available



//client.query "INSERT INTO beatles(name, height, birthday) values($1, $2, $3)", ["John", 68, new Date(1944, 10, 13)]

exports.Search (term)->
	query = client.query("SELECT * FROM forms WHERE title LIKE $1", [term])

#can stream row results back 1 at a time
query.on "row", (row) ->
  console.log row
  console.log "Beatle name: %s", row.name #Beatle name: John
  console.log "Beatle birth year: %d", row.birthday.getYear() #dates are returned as javascript dates
  console.log "Beatle height: %d' %d\"", Math.floor(row.height / 12), row.height % 12 #integers are returned as javascript ints


#fired after last row is emitted
query.on "end", ->
  client.end()
