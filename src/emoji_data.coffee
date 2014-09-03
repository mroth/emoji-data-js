EmojiChar = require('./emoji_char')
punycode = require('punycode')
_str = require('underscore.string')

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

  # An array of all known emoji chars rendered as UCS-2 strings.
  @chars: (options = {include_variants: false}) ->
    norms = (ec.render({variant_encoding: false}) for ec in EMOJI_CHARS)
    extra = (ec.render({variant_encoding: true}) for ec in @all_with_variants())
    return norms.concat(extra) if options.include_variants
    norms

  # An array of all known emoji glyph codepoints
  @codepoints: (options = {include_variants: false}) ->
    norms = (ec.unified   for ec in EMOJI_CHARS)
    extra = (ec.variant() for ec in @all_with_variants())
    return norms.concat(extra) if options.include_variants
    norms

  # Convert a native string glyph to a unified ID.
  #
  # This is a conversion operation, not a match, so it may produce unexpected
  # results with different types of values.
  @char_to_unified: (char) ->
    cps = punycode.ucs2.decode(char)
    hexes = ( _str.rjust( cp.toString(16), 4, "0") for cp in cps )
    hexes.join("-").toUpperCase()

  # Convert a unified codepoint ID to the UCS-2 string representation.
  #
  # @param [String] uid the unified codepoint ID for an emoji
  # @return [String] UCS-2 string representation of the emoji glyph
  @unified_to_char: (uid) ->
    EmojiChar._unified_to_char(uid)


  # Find all EmojiChars that match a contain substring in their official name.
  @find_by_name: (name) ->
    target = name.toUpperCase()
    (ec for ec in EMOJI_CHARS when ec.name.indexOf(target) != -1)

  # Find all EmojiChars that match a contain substring in their short name.
  @find_by_short_name: (name) ->
    target = name.toLowerCase()
    (ec for ec in EMOJI_CHARS when ec.short_names.some(
      (sn)->sn.indexOf(target) != -1
    ))

  # singleton keyword lookups will likely be popular here, so make a cache
  EMOJICHAR_KEYWORD_MAP = {}
  for ec in EMOJI_CHARS
    EMOJICHAR_KEYWORD_MAP[keyword] = ec for keyword in ec.short_names

  # Quickly lookup a EmojiChar based on shortname/keyword.  Must be exact match.
  @from_short_name: (name)  ->
    EMOJICHAR_KEYWORD_MAP[name.toLowerCase()]

  #
  # construct hashmap for fast precached lookups for `.from_unified`
  #
  EMOJICHAR_UNIFIED_MAP = {}
  for char in EMOJI_CHARS
    EMOJICHAR_UNIFIED_MAP[char.unified] = char
    EMOJICHAR_UNIFIED_MAP[variant] = char for variant in char.variations

  # Find a specific EmojiChar by its unified ID.
  @from_unified: (uid) ->
    EMOJICHAR_UNIFIED_MAP[uid.toUpperCase()]

  # The RegExp matcher we use to do find_by_str efficiently.
  FBS_REGEXP = new RegExp(
    "(?:#{EmojiData.chars({include_variants: true}).join("|")})",
    "g"
  )

  # Search a string for all EmojiChars contained within.
  #
  # Returns an array of all EmojiChars contained within that string, in order.
  @scan: (str) ->
    # since JS doesnt seem to have the equivalent of .scan we do some hacky shit
    # http://stackoverflow.com/questions/13895373/

    # reset regexp pointer (really js? sigh)
    FBS_REGEXP.lastIndex = 0

    # keep executing regex until it returns no more results
    matches = []
    while (m = FBS_REGEXP.exec(str))
      matches.push(m[0])

    # map matched chars to EmojiChar objects
    (@from_unified( @char_to_unified(id) ) for id in matches)


module.exports = EmojiData
module.exports.EmojiChar = EmojiChar
