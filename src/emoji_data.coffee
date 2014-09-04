EmojiChar = require('./emoji_char')
punycode = require('punycode')
_str = require('underscore.string')

class EmojiData
  EMOJI_MAP = require('../vendor/emoji-data/emoji.json')
  EMOJI_CHARS = (new EmojiChar(char_blob) for char_blob in EMOJI_MAP)

  # construct hashmap for fast precached lookups for `.from_unified`
  EMOJICHAR_UNIFIED_MAP = {}
  for ec in EMOJI_CHARS
    EMOJICHAR_UNIFIED_MAP[ec.unified] = ec
    EMOJICHAR_UNIFIED_MAP[variant] = ec for variant in ec.variations

  # precomputed hashmap for fast precached lookups in .from_short_name
  EMOJICHAR_KEYWORD_MAP = {}
  for ec in EMOJI_CHARS
    EMOJICHAR_KEYWORD_MAP[keyword] = ec for keyword in ec.short_names


  # Returns a list of all known Emoji characters as `EmojiChar` objects.
  #
  # @return [Array<EmojiChar>] a list of all known `EmojiChar`.
  @all: ->
    EMOJI_CHARS

  # Returns a list of all `EmojiChar` that are represented with doublebyte
  # encoding.
  #
  # @return [Array<EmojiChar>] a list of all doublebyte `EmojiChar`.
  @all_doublebyte: ->
    ( ec for ec in EMOJI_CHARS when ec.is_doublebyte() )

  # Returns a list of all `EmojiChar` that have at least one variant encoding.
  #
  # @return [Array<EmojiChar>] a list of all `EmojiChar` with variant encoding.
  @all_with_variants: ->
    ( ec for ec in EMOJI_CHARS when ec.has_variants() )

  # Returns a list of all known Emoji characters rendered as UCS-2 strings.
  #
  # By default, the default rendering options for this library will be used.
  # However, if you pass an option hash with `include_variants: true` then all
  # possible renderings of a single glyph will be included, meaning that:
  #
  # 1. You will have "duplicate" emojis in your list.
  # 2. This list is now suitable for exhaustably matching against in a search.
  #
  # @option options [Boolean] :include_variants whether or not to include all
  #   possible encoding variants in the list
  #
  # @return [Array<String>] all Emoji characters rendered as UTF-8 strings
  @chars: (options = {include_variants: false}) ->
    norms = (ec.render({variant_encoding: false}) for ec in EMOJI_CHARS)
    extra = (ec.render({variant_encoding: true}) for ec in @all_with_variants())
    return norms.concat(extra) if options.include_variants
    norms

  # Returns a list of all known codepoints representing Emoji characters.
  #
  # @option options [Boolean] :include_variants whether or not to include all
  #   possible encoding variants in the list
  # @return [Array<String>] all codepoints represented as unified ID strings
  @codepoints: (options = {include_variants: false}) ->
    norms = (ec.unified   for ec in EMOJI_CHARS)
    extra = (ec.variant() for ec in @all_with_variants())
    return norms.concat(extra) if options.include_variants
    norms

  # Convert a native UCS-2 string glyph to its unified codepoint ID.
  #
  # This is a conversion operation, not a match, so it may produce unexpected
  # results with different types of values.
  #
  # @param char [String] a single rendered emoji glyph encoded as a UCS-2 string
  # @return [String] the unified ID
  #
  # @example
  #   > EmojiData.unified_to_char("1F47E");
  #   '👾'
  @char_to_unified: (char) ->
    cps = punycode.ucs2.decode(char)
    hexes = ( _str.rjust( cp.toString(16), 4, "0") for cp in cps )
    hexes.join("-").toUpperCase()

  # Convert a unified codepoint ID directly to its UCS-2 string representation.
  #
  # @param uid [String] the unified codepoint ID for an emoji
  # @return [String] UCS-2 string rendering of the emoji character
  #
  # @example
  #   > EmojiData.char_to_unified("👾");
  #   '1F47E'
  @unified_to_char: (uid) ->
    EmojiChar._unified_to_char(uid)

  # Finds any `EmojiChar` that contains given string in its official name.
  #
  # @param name [String]
  # @return [Array<EmojiChar>]
  @find_by_name: (name) ->
    target = name.toUpperCase()
    (ec for ec in EMOJI_CHARS when ec.name.indexOf(target) != -1)

  # Find all `EmojiChar` that match string in any of their associated short
  # name keywords.
  #
  # @param short_name [String]
  # @return [Array<EmojiChar>]
  @find_by_short_name: (short_name) ->
    target = short_name.toLowerCase()
    (ec for ec in EMOJI_CHARS when ec.short_names.some(
      (sn)->sn.indexOf(target) != -1
    ))

  # Finds a specific `EmojiChar` based on the unified codepoint ID.
  #
  # Must be exact match.
  #
  # @param short_name [String]
  # @return [EmojiChar]
  @from_short_name: (short_name)  ->
    EMOJICHAR_KEYWORD_MAP[short_name.toLowerCase()]

  # Finds a specific `EmojiChar` based on its unified codepoint ID.
  #
  # @param uid [String] the unified codepoint ID for an emoji
  # @return [EmojiChar]
  @from_unified: (uid) ->
    EMOJICHAR_UNIFIED_MAP[uid.toUpperCase()]

  # The RegExp matcher we use to do .scan() efficiently.
  # needs to be defined after self.chars so not at top of file for now...
  FBS_REGEXP = new RegExp(
    "(?:#{EmojiData.chars({include_variants: true}).join("|")})",
    "g"
  )

  # Scans a string for all encoded emoji characters contained within.
  #
  # @param str [String] the target string to search
  # @return [Array<EmojiChar>] all emoji characters contained within the target
  #    string, in the order they appeared.
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
