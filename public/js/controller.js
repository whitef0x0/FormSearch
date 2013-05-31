(function() {
  var results, source, template;

  source = $("#entry-template").html();

  template = Handlebars.compile(source);

  String.prototype.trim = function() {
    return this.replace(/^\s+|\s+$/g, '');
  };

  results = {};

  $("#upload").click(function() {
    return $.get("/upload", function(data) {
      $("#search").hide();
      console.log(data);
      return $(".container").html(data);
    });
  });

  $("#omnibox").keyup(function(e) {
    var context, html, key, out_results, result, score, term, terms, _i, _j, _len, _len2;
    key = e.keyCode || e.which;
    terms = $(this).val().trim().split(" ");
    out_results = [];
    score = 0;
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
      if (result.score > 0) {
        console.log(result.score);
        out_results.push(result);
      }
    }
    out_results.sort(function(a, b) {
      return b.score - a.score;
    });
    context = {
      results: out_results
    };
    html = template(context);
    if ((out_results + ' ' === ' ' && $("#omnibox").val() !== '') && terms[0].length >= 2) {
      $(".results").html('<br> <i> <p class = "lead"> The search term(s) "' + terms + '" did not yield any results. <br> Check your spelling and try again </p></i>');
    } else {
      $(".results").empty();
      $(".results").html(html);
    }
    return $.get('/api/results', function(rsp) {
      return results = rsp;
    });
  });

}).call(this);
