punycode = require('punycode')

class EmojiChar

  # give me the JSON blob entry from emojidata
  constructor: (blob) ->
    @[k] = v for k,v of blob
    # source file doesnt include blank variations field if none exist,
    # for our sake, lets add that here.
    @variations = [] unless @variations?

  # Is the character represented by a doublebyte unicode codepoint in UTF-8?
  #
  # @return [Boolean] true when the EmojiChar is doublebyte
  is_doublebyte: ->
    @unified.match(/-/) isnt null

  # Does the character have any variant encodings?
  #
  # @return [Boolean] true when the EmojiChar has at least one variant encoding
  has_variants: ->
    @variations.length > 0

  # The most likely variant ID of the char
  #
  # @return [String] the unified variant ID
  variant: ->
    return null unless @variations.length > 0
    @variations[0]

  # Renders a UCS-2 string representation of the glyph for writing to the screen.
  #
  # If you want to specify whether or not to use variant encoding, pass an
  # options hash such as:
  #
  #     foo.char({variant_encoding: true})
  #
  # By default this will use the variant encoding if it exists.
  #
  # @param [Object] options the encoding options
  # @option options [Boolean] variant_encoding true if you want to render with variant encoding.
  #
  char: ({variant_encoding} = {variant_encoding: true}) ->
    target = if (@has_variants() && variant_encoding) then @variant() else @unified
    EmojiChar.unified_to_char(target)


  # Returns an array of all possible string renderings of the glyph (normal and
  # variant encoded).
  chars: ->
    (EmojiChar.unified_to_char(id) for id in [@unified].concat(@variations))

  # Convert a unified codepoint ID to the UCS-2 string representation.
  #
  # @param [String] uid the unified codepoint ID for an emoji
  # @return [String] UCS-2 string representation of the emoji glyph
  @unified_to_char: (uid) ->
    cps = (parseInt(cp, 16) for cp in uid.split('-'))
    punycode.ucs2.encode(cps)



module.exports = EmojiChar
