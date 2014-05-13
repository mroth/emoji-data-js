EmojiChar = require('./emoji_char')

class EmojiData
  EMOJI_MAP = require('../vendor/emoji-data/emoji.json')
  EMOJI_CHARS = (new EmojiChar(char_blob) for char_blob in EMOJI_MAP)

  # Returns an array of all known EmojiChar.
  @all: ->
    EMOJI_CHARS

  # Returns an array of all EmojiChar that are doublebyte encoded.
  @all_doublebyte: ->
    ( ec for ec in EMOJI_CHARS when ec.is_doublebyte() )

  # Returns an array of all EmojiChar that have Unicode variant encoding.
  @all_with_variants: ->
    ( ec for ec in EMOJI_CHARS when ec.has_variants() )


module.exports = EmojiData
module.exports.EmojiChar = EmojiChar
