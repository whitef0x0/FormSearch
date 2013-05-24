(function() {
  var client, conString, pg;

  pg = require("pg");

  conString = "tcp://admin:halflife2@localhost/forms";

  client = new pg.Client(conString);

  client.connect();

  exports.Upload = function(callback) {
    var query;
    return query = client.query('INSERT INTO reasons (name) VALUES ({#file.reason}) AND\nINSERT INTO places (name, city) VALUES ({#file.location.name}, {#file.location.city}) AND\nINSERT INTO forms (title, is_pediatric) VALUES ({#file.title},{#file.is_ped}) ');
  };

  exports.Search = function(callback) {
    var query, results;
    query = client.query('SELECT r.name, p.name, p.city, f.title\nFROM\nreasons as r, places as p, forms as f\nWHERE\nf.reason_id = r.id AND f.place_id = p.id');
    results = [];
    query.on("row", function(row) {
      results.push(row);
      return console.log(results);
    });
    return query.on("end", function() {
      callback(results);
      return client.end();
    });
  };

}).call(this);
