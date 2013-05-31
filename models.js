(function() {
  var client, conString, pg;

  pg = require("pg");

  conString = "tcp://admin:halflife2@localhost/forms";

  client = new pg.Client(conString);

  client.connect();

  exports.Upload = function(callback) {
    var query;
    return query = client.query('with rows as(INSERT INTO reasons (name) VALUES ({#file.reason}) RETURNING pid AND\nINSERT INTO places (name, city) VALUES ({#file.location.name}, {#file.location.city}) RETURNING rid);\nINSERT INTO forms (title, is_pediatric, reason_id, place_id) VALUES ({#file.title},{#file.is_ped}, rid, pid);');
  };

  exports.Search = function(callback) {
    var query, results;
    query = client.query('SELECT r.name, p.name, p.city, f.title, f.filename, f.is_pediatric\nFROM\nreasons as r, places as p, forms as f\nWHERE\nf.reason_id = r.id AND f.place_id = p.id');
    results = [];
    query.on("row", function(row) {
      results.push(row);
      return console.log(results);
    });
    return query.on("end", function() {
      return callback(results);
    });
  };

}).call(this);
