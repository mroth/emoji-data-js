EmojiChar = require('./emoji_char')

class EmojiData
  EMOJI_MAP = require('../vendor/emoji-data/emoji.json')
  EMOJI_CHARS = (new EmojiChar(char_blob) for char_blob in EMOJI_MAP)

  constructor: ->

  all: ->
    EMOJI_CHARS


module.exports = new EmojiData
module.exports.EmojiChar = EmojiChar
