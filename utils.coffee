
String::trim = ->
  @replace /^\s+|\s+$/g, ""

module.exports.hash = (input)->
  hash = 0
  i = undefined
  char = undefined
  return hash  if input.length is 0
  i = 0
  l = @length

  while i < l
    char = @charCodeAt(i)
    hash = ((hash << 5) - hash) + char
    hash |= 0 # Convert to 32bit integer
    i++
  Math.abs hash

module.exports.slugify = (phrase)->
    #phrase = phrase.replace("-", " ").lower()
    phrase = phrase.toLowerCase().replace /[^a-z\d]/g," "
    phrase = phrase.trim()
    while (phrase.indexOf '  ') > -1
      phrase = phrase.replace /\s\s/g, ' '

    return phrase.replace /\s/g, "-"