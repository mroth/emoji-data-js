class EmojiChar

  # give me the JSON blob entry from emojidata
  constructor: (blob) ->
    @[k] = v for k,v of blob

  # Is the character represented by a doublebyte unicode codepoint in UTF-8?
  #
  # Returns boolean
  is_doublebyte: ->
    @unified.match(/-/) isnt null


module.exports = EmojiChar
