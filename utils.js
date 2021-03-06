// Generated by CoffeeScript 1.6.2
(function() {
  String.prototype.trim = function() {
    return this.replace(/^\s+|\s+$/g, "");
  };

  module.exports.hash = function(input) {
    var char, hash, i, l;

    hash = 0;
    i = void 0;
    char = void 0;
    if (input.length === 0) {
      return hash;
    }
    i = 0;
    l = this.length;
    while (i < l) {
      char = this.charCodeAt(i);
      hash = ((hash << 5) - hash) + char;
      hash |= 0;
      i++;
    }
    return Math.abs(hash);
  };

  module.exports.slugify = function(phrase) {
    phrase = phrase.toLowerCase().replace(/[^a-z\d]/g, " ");
    phrase = phrase.trim();
    while ((phrase.indexOf('  ')) > -1) {
      phrase = phrase.replace(/\s\s/g, ' ');
    }
    return phrase.replace(/\s/g, "-");
  };

}).call(this);
