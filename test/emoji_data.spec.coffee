require 'coffee-errors'

chai = require 'chai'
sinon = require 'sinon'
_ = require 'lodash'

# using compiled JavaScript file here to be sure module works
EmojiData = require '../lib/emoji_data.js'

# expect = chai.expect
chai.should()

chai.use require 'sinon-chai'


describe 'EmojiData', ->
  describe ".all", ->
    it "should return an array of all 845 known emoji chars", ->
      EmojiData.all().length.should.equal 845

    it "should return all EmojiChar objects", ->
      result.should.be.an.instanceof(EmojiData.EmojiChar) for result in EmojiData.all()


  describe ".all_doublebyte", ->
    it "should return an array of all 21 known emoji chars with doublebyte encoding", ->
      results = EmojiData.all_doublebyte()
      results.length.should.equal 21
      result.should.be.an.instanceof(EmojiData.EmojiChar) for result in results


  describe ".all_with_variants", ->
    it "should return an array of all 107 known emoji chars with variant encodings", ->
      results = EmojiData.all_with_variants()
      results.length.should.equal 107
      result.should.be.an.instanceof(EmojiData.EmojiChar) for result in results


  describe ".chars", ->
    it "should return an array of all chars in unicode string format", ->
      char.should.be.a('String') for char in EmojiData.chars()

    it "should by default return one entry per known EmojiChar", ->
      EmojiData.chars().length.should.equal EmojiData.all().length

    it "should include variants in list when options {include_variants: true}", ->
      results = EmojiData.chars({include_variants: true})
      numChars = EmojiData.all().length
      numVariants = EmojiData.all_with_variants().length
      results.length.should.equal numChars + numVariants

    it "should not have any duplicates in list when variants are included", ->
      results = EmojiData.chars({include_variants: true})
      results.length.should.equal _.uniq(results).length

  describe ".codepoints", ->
    it "should return an array of all known codepoints in dashed string representation", ->
      results = EmojiData.codepoints()
      results.length.should.equal 845
      for result in results
        result.should.be.a 'string'
        result.should.match /^[0-9A-F\-]{4,11}$/

    it "should include variants in list when options {include_variants: true}", ->
      numChars    = EmojiData.all().length
      numVariants = EmojiData.all_with_variants().length
      results = EmojiData.codepoints({include_variants: true})
      results.length.should.equal (numChars + numVariants)
      for result in results
        result.should.be.a 'string'
        result.should.match /^[0-9A-F\-]{4,16}$/


  describe ".scan", ->
    before ->
      @exact_results   = EmojiData.scan("🚀")
      @multi_results   = EmojiData.scan("flying on my 🚀 to visit the 👾 people.")
      @variant_results = EmojiData.scan("\u0023\uFE0F\u20E3")
      @variant_multi   = EmojiData.scan("first a \u0023\uFE0F\u20E3 then a 🚀")

    it "should find the proper EmojiChar object from a single string char", ->
      @exact_results.should.be.a 'array'
      @exact_results.length.should.equal 1
      @exact_results[0].should.be.an.instanceof EmojiData.EmojiChar
      @exact_results[0].name.should.equal 'ROCKET'

    it "should find the proper EmojiChar object from a variant encoded char", ->
      @variant_results.length.should.equal 1
      @variant_results[0].name.should.equal 'HASH KEY'

    it "should match multiple chars from within a string", ->
      @multi_results.should.be.a 'array'
      @multi_results.length.should.equal 2
      @multi_results[0].should.be.an.instanceof EmojiData.EmojiChar
      @multi_results[1].should.be.an.instanceof EmojiData.EmojiChar

    it "should return multiple matches in the proper order", ->
      @multi_results[0].name.should.equal 'ROCKET'
      @multi_results[1].name.should.equal 'ALIEN MONSTER'

    it "should return multiple matches in the proper order for variant encodings", ->
      @variant_multi[0].name.should.equal 'HASH KEY'
      @variant_multi[1].name.should.equal 'ROCKET'

    it "should return multiple matches including duplicates", ->
      results = EmojiData.scan("flying my 🚀 to visit the 👾 people who have their own 🚀 too.")
      results.should.be.a 'array'
      results.length.should.equal 3

    it "returns [] if nothing is found", ->
      EmojiData.scan("i like turtles").should.deep.equal []


  describe ".from_unified", ->
    it "should find the proper EmojiChar object", ->
      results = EmojiData.from_unified('1F680')
      results.should.be.an.instanceof(EmojiData.EmojiChar)
      results.name.should.equal 'ROCKET'

    it "should normalise capitalization for hex values", ->
      EmojiData.from_unified('1f680').should.deep.equal EmojiData.from_unified('1F680')

    it "should find via variant encoding ID format as well", ->
      results = EmojiData.from_unified('2764-fe0f')
      results.should.be.an.instanceof(EmojiData.EmojiChar)
      results.name.should.equal 'HEAVY BLACK HEART'


  describe ".find_by_name", ->
    it "returns an array of results, upcasing input if needed", ->
      EmojiData.find_by_name('tree').should.be.a 'array'
      EmojiData.find_by_name('tree').length.should.equal 5

    it "returns [] if nothing is found", ->
      EmojiData.find_by_name('sdlkfjlskdfj').should.deep.equal []


  describe ".find_by_short_name", ->
    it "returns an array of results, downcasing input if needed", ->
      EmojiData.find_by_short_name('MOON').should.be.a 'array'
      EmojiData.find_by_short_name('MOON').length.should.equal 13

    it "returns [] if nothing is found", ->
      EmojiData.find_by_short_name('sdlkfjlskdfj').should.deep.equal []


  describe ".from_short_name", ->
    it "returns exact matches on a short name"
    it "returns undefined if nothing matches"


  describe ".char_to_unified", ->
    it "converts normal emoji to unified codepoint", ->
      EmojiData.char_to_unified("👾").should.equal '1F47E'
      EmojiData.char_to_unified("🚀").should.equal '1F680'

    it "converts double-byte emoji to proper codepoint", ->
      EmojiData.char_to_unified("🇺🇸").should.equal '1F1FA-1F1F8'

    it "in doublebyte, adds padding to hex codes that are <4 chars", ->
      EmojiData.char_to_unified("#⃣").should.equal '0023-20E3'

    it "converts variant encoded emoji to variant unified codepoint", ->
      EmojiData.char_to_unified("\u2601\uFE0F").should.equal '2601-FE0F'


  describe ".unified_to_char", ->
    it "converts normal unified codepoints to unicode strings", ->
      EmojiData.unified_to_char('1F47E').should.equal "👾"
      EmojiData.unified_to_char('1F680').should.equal "🚀"

    it "converts doublebyte unified codepoints to unicode strings", ->
      EmojiData.unified_to_char('1F1FA-1F1F8').should.equal "🇺🇸"
      EmojiData.unified_to_char('0023-20E3').should.equal "#⃣"

    it "converts variant unified codepoints to unicode strings", ->
      EmojiData.unified_to_char('2764-fe0f').should.equal "\u2764\uFE0F"

    it "converts variant+doublebyte chars (triplets!) to unicode strings", ->
      EmojiData.unified_to_char('0030-FE0F-20E3').should.equal "\u0030\uFE0F\u20E3"
