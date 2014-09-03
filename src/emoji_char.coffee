punycode = require('punycode')

# EmojiChar represents a single Emoji character and its associated metadata.
#
# ## Properties
#
# * `name` - The standardized name used in the Unicode specification to
#   represent this emoji character.
# * `unified` - The primary unified codepoint ID for the emoji.
# * `variations` - A list of all variant codepoints that may also represent this
#   emoji.
# * `short_name` - The canonical "short name" or keyword used in many systems to
#   refer to this emoji. Often surrounded by `:colons:` in systems like GitHub
#   & Campfire.
# * `short_names` - A full list of possible keywords for the emoji.
# * `text` - An alternate textual representation of the emoji, for example a
#   smiley face emoji may be represented with an ASCII alternative. Most emoji
#   do not have a text alternative. This is typically used when building an
#   automatic translation from typed emoticons.
#
# It also contains a few helper functions to deal with this data type.
#
class EmojiChar

  # @param blob [Object] the JSON blob entry from emoji-data
  # @return [EmojiChar]
  constructor: (blob) ->
    @[k] = v for k,v of blob
    # source file doesnt include blank variations field if none exist,
    # for our sake, lets add that here.
    @variations = [] unless @variations?

  # Is the `EmojiChar` represented by a doublebyte codepoint in Unicode?
  #
  # @return [Boolean]
  is_doublebyte: ->
    @unified.indexOf('-') isnt -1

  # Does the `EmojiChar` have an alternate Unicode variant encoding?
  #
  # @return [Boolean] true when the EmojiChar has at least one variant encoding
  has_variants: ->
    @variations.length > 0

  # Returns the most likely variant-encoding codepoint ID for an `EmojiChar`.
  #
  # For now we only know of one possible variant encoding for certain
  # characters, but there could be others in the future.
  #
  # This is typically used to force Emoji rendering for characters that could
  # be represented in standard font glyphs on certain operating systems.
  #
  # The resulting encoded string will be two codepoints, or three codepoints
  # for doublebyte Emoji characters.
  #
  # @return [String, null]
  #   The most likely variant-encoding codepoint ID.
  #   If there is no variant-encoding for a character, returns null.
  variant: ->
    return null unless @variations.length > 0
    @variations[0]

  # Renders a UCS-2 string representation of the glyph for writing to screen.
  #
  # If you want to specify whether or not to use variant encoding, pass an
  # options hash such as:
  #
  #     foo.char({variant_encoding: true})
  #
  # By default this will use the variant encoding if it exists.
  #
  # @param options [Object] the encoding options
  # @option options [Boolean] variant_encoding true if you want to render with
  # variant encoding.
  #
  # @return [String] the emoji character rendered to a UCS-2 string
  render: ({variant_encoding} = {variant_encoding: true}) ->
    target = switch
      when @has_variants() && variant_encoding then @variant()
      else @unified

    EmojiChar._unified_to_char(target)

  # Returns a list of all possible UTF-8 string renderings of an `EmojiChar`.
  #
  # E.g., normal, with variant selectors, etc. This is useful if you want to
  # have all possible values to match against when searching for the emoji in
  # a string representation.
  #
  # @return [Array<String>] all possible UCS-2 string renderings
  chars: ->
    (EmojiChar._unified_to_char(id) for id in [@unified].concat(@variations))

  # @see `#render()`
  # @return [String]
  toString: -> @render()

  # Convert a unified codepoint ID to the UCS-2 string representation.
  #
  # @param [String] uid the unified codepoint ID for an emoji
  # @return [String] UCS-2 string representation of the emoji glyph
  # @private
  @_unified_to_char: (uid) ->
    cps = (parseInt(cp, 16) for cp in uid.split('-'))
    punycode.ucs2.encode(cps)


module.exports = EmojiChar
