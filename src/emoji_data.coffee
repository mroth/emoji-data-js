EmojiChar = require('./emoji_char')
punycode = require('punycode')
_ = require('lodash')
_.str = require('underscore.string')

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
    normals = (ec.char({variant_encoding: false}) for ec in EMOJI_CHARS)
    extras  = (ec.char({variant_encoding: true} ) for ec in @all_with_variants())
    return normals.concat(extras) if options.include_variants
    normals

  # Convert a native string glyph to a unified ID.
  #
  # This is a conversion operation, not a match, so it may produce unexpected
  # results with different types of values.
  @char_to_unified: (char) ->
    cps = punycode.ucs2.decode(char)
    hexes = ( _.str.rjust( cp.toString(16), 4, "0") for cp in cps )
    hexes.join("-").toUpperCase()

  # Find all EmojiChars that match a contain substring in their official name.
  @find_by_name: (name) ->
    (ec for ec in EMOJI_CHARS when ec.name.indexOf(name.toUpperCase()) != -1)

  # Find all EmojiChars that match a contain substring in their short name.
  @find_by_short_name: (name) ->
    (ec for ec in EMOJI_CHARS when _.any(
        ec.short_names,
        (sn)->sn.indexOf(name.toLowerCase()) != -1
      )
    )

  #TODO: singleton lookups will likely be popular here, so make a cache for that
  @from_short_name: (name)  ->
    null

  #
  # construct hashmap for fast precached lookups for `.find_by_unified`
  #
  EMOJICHAR_UNIFIED_MAP = {}
  for char in EMOJI_CHARS
    EMOJICHAR_UNIFIED_MAP[char.unified] = char
    EMOJICHAR_UNIFIED_MAP[variant] = char for variant in char.variations

  # Find a specific EmojiChar by its unified ID.
  @find_by_unified: (uid) ->
    EMOJICHAR_UNIFIED_MAP[uid.toUpperCase()]

  # The RegExp matcher we use to do find_by_str efficiently.
  FBS_REGEXP = new RegExp("(?:#{EmojiData.chars({include_variants: true}).join("|")})", "g")

  # Search a string for all EmojiChars contained within.
  #
  # Returns an array of all EmojiChars contained within that string, in order.
  @find_by_str: (str) ->
    # since JS doesnt seem to have the equivalent of .scan we do some hacky shit
    # http://stackoverflow.com/questions/13895373/

    # reset regexp pointer (really js? sigh)
    FBS_REGEXP.lastIndex = 0

    # keep executing regex until it returns no more results
    matches = []
    while (m = FBS_REGEXP.exec(str))
      matches.push(m[0])

    # map matched chars to EmojiChar objects
    (@find_by_unified( @char_to_unified(id) ) for id in matches)


module.exports = EmojiData
module.exports.EmojiChar = EmojiChar
