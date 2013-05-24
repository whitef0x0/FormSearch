(function() {
  var results, source, template;

  source = $("#entry-template").html();

  template = Handlebars.compile(source);

  String.prototype.trim = function() {
    return this.replace(/^\s+|\s+$/g, '');
  };

  results = {};

  $("#omnibox").keyup(function() {
    var context, html, out_results, result, term, terms, _i, _j, _len, _len2;
    terms = $(this).val().trim().split(" ");
    out_results = [];
    for (_i = 0, _len = results.length; _i < _len; _i++) {
      result = results[_i];
      result.score = 0;
      for (_j = 0, _len2 = terms.length; _j < _len2; _j++) {
        term = terms[_j];
        if (!term) continue;
        term = term.toLowerCase();
        if (result.name.toLowerCase().indexOf(term) > -1) result.score += 1;
        if (result.city.toLowerCase().indexOf(term) > -1) result.score += 1;
        if (result.title.toLowerCase().indexOf(term) > -1) result.score += 1;
      }
      if (result.score > 0) out_results.push(result);
    }
    out_results.sort(function(a, b) {
      return b.score - a.score;
    });
    context = {
      results: out_results
    };
    console.log(context.results);
    html = template(context);
    return $(".results").html(html);
  });

  $.get('/api/results', function(rsp) {
    return results = rsp;
  });

  $.get('/api/upload', function(rsp) {
    return results = rsp;
  });

}).call(this);
