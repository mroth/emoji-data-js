class EmojiChar

  # give me the JSON blob entry from emojidata
  constructor: (blob) ->
    @[k] = v for k,v of blob

  # Is the character represented by a doublebyte unicode codepoint in UTF-8?
  #
  # Returns boolean
  is_doublebyte: ->
    @unified.match(/-/) isnt null

  # Does the character have any variant encodings?
  #
  # Returns boolean
  has_variants: ->
    return false unless @variations?
    @variations.length > 0

  # The most likely variant ID of the char
  #
  # Returns a string of the unified variant ID
  variant: ->
    return null unless @variations? && @variations.length > 0
    @variations[0]


module.exports = EmojiChar
