String::hashCode = ->
  hash = 0
  i = undefined
  char = undefined
  return hash  if @length is 0
  i = 0
  l = @length

  while i < l
    char = @charCodeAt(i)
    hash = ((hash << 5) - hash) + char
    hash |= 0 # Convert to 32bit integer
    i++
  Math.abs hash