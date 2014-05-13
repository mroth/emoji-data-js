punycode = require('punycode')

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

  # Returns a UCS-2 string representation of the glyph for rendering to screen.
  #
  # If you want to specify whether or not to use variant encoding, pass an
  # options hash such as:
  #
  #     foo.char({variant_encoding: true})
  #
  # By default this will use the variant encoding if it exists.
  char: ({variant_encoding} = {variant_encoding: true}) ->
    target = if (@has_variants() && variant_encoding) then @variant() else @unified
    EmojiChar.unified_to_char(target)

  @unified_to_char: (uid) ->
    cps = (parseInt(cp, 16) for cp in uid.split('-'))
    punycode.ucs2.encode(cps)



module.exports = EmojiChar
