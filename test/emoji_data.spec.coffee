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
    it "should return an array of all known codepoints in dashed string representation"
      # EmojiData.codepoints.all? {|cp| cp.class == String}.should be_true
      # EmojiData.codepoints.all? {|cp| cp.match(/^[0-9A-F\-]{4,11}$/)}.should be_true

    it "should include variants in list when options {include_variants: true}"
      # results = EmojiData.codepoints({include_variants: true})
      # numChars    = EmojiData.all.count
      # numVariants = EmojiData.all_with_variants.count
      # results.count.should eq(numChars + numVariants)
      # results.all? {|cp| cp.match(/^[0-9A-F\-]{4,16}$/)}.should be_true

  describe ".find_by_str", ->
    # before(:all), ->
    #   @exact_results   = EmojiData.find_by_str("🚀")
    #   @multi_results   = EmojiData.find_by_str("flying on my 🚀 to visit the 👾 people.")
    #   @variant_results = EmojiData.find_by_str("\u{0023}\u{FE0F}\u{20E3}")
    #   @variant_multi   = EmojiData.find_by_str("first a \u{0023}\u{FE0F}\u{20E3} then a 🚀")

    it "should find the proper EmojiChar object from a single string char"
      # @exact_results.should be_kind_of(Array)
      # @exact_results.length.should eq(1)
      # @exact_results.first.should be_kind_of(EmojiChar)
      # @exact_results.first.name.should eq('ROCKET')

    it "should find the proper EmojiChar object from a variant encoded char"
      # @variant_results.length.should eq(1)
      # @variant_results.first.name.should eq('HASH KEY')

    it "should match multiple chars from within a string"
      # @multi_results.should be_kind_of(Array)
      # @multi_results.length.should eq(2)
      # @multi_results[0].should be_kind_of(EmojiChar)
      # @multi_results[1].should be_kind_of(EmojiChar)

    it "should return multiple matches in the proper order"
      # @multi_results[0].name.should eq('ROCKET')
      # @multi_results[1].name.should eq('ALIEN MONSTER')

    it "should return multiple matches in the proper order for variant encodings"
      # @variant_multi[0].name.should eq('HASH KEY')
      # @variant_multi[1].name.should eq('ROCKET')


  describe ".find_by_unified", ->
    it "should find the proper EmojiChar object"
      # results = EmojiData.find_by_unified('1f680')
      # results.should be_kind_of(EmojiChar)
      # results.name.should eq('ROCKET')

    it "should normalise capitalization for hex values"
      # EmojiData.find_by_unified('1f680').should_not be_nil

    it "should find via variant encoding ID format as well"
      # results = EmojiData.find_by_unified('2764-fe0f')
      # results.should_not be_nil
      # results.name.should eq('HEAVY BLACK HEART')


  describe ".find_by_name", ->
    it "returns an array of results, upcasing input if needed"
      # EmojiData.find_by_name('tree').should be_kind_of(Array)
      # EmojiData.find_by_name('tree').count.should eq(5)

    it "returns [] if nothing is found"
      # EmojiData.find_by_name('sdlkfjlskdfj').should_not be_nil
      # EmojiData.find_by_name('sdlkfjlskdfj').should be_kind_of(Array)
      # EmojiData.find_by_name('sdlkfjlskdfj').count.should eq(0)

  describe ".find_by_short_name", ->
    it "returns an array of results, downcasing input if needed"
      # EmojiData.find_by_short_name('MOON').should be_kind_of(Array)
      # EmojiData.find_by_short_name('MOON').count.should eq(13)

    it "returns [] if nothing is found"
      # EmojiData.find_by_short_name('sdlkfjlskdfj').should_not be_nil
      # EmojiData.find_by_short_name('sdlkfjlskdfj').should be_kind_of(Array)
      # EmojiData.find_by_short_name('sdlkfjlskdfj').count.should eq(0)


  describe ".char_to_unified", ->
    it "converts normal emoji to unified codepoint"
      # EmojiData.char_to_unified("👾").should eq('1F47E')
      # EmojiData.char_to_unified("🚀").should eq('1F680')

    it "converts double-byte emoji to proper codepoint"
      # EmojiData.char_to_unified("🇺🇸").should eq('1F1FA-1F1F8')
      # EmojiData.char_to_unified("#⃣").should eq('0023-20E3')

    it "converts variant encoded emoji to variant unified codepoint"
      # EmojiData.char_to_unified("\u{2601}\u{FE0F}").should eq('2601-FE0F')


  # TODO: below is kinda redundant but it is helpful as a helper method so maybe still test
  describe ".unified_to_char", ->
    it "converts normal unified codepoints to unicode strings"
      # EmojiData.unified_to_char('1F47E').should eq("👾")
      # EmojiData.unified_to_char('1F680').should eq("🚀")

    it "converts doublebyte unified codepoints to unicode strings"
      # EmojiData.unified_to_char('1F1FA-1F1F8').should eq("🇺🇸")
      # EmojiData.unified_to_char('0023-20E3').should eq("#⃣")

    it "converts variant unified codepoints to unicode strings"
      # EmojiData.unified_to_char('2764-fe0f').should eq("\u{2764}\u{FE0F}")

    it "converts variant+doublebyte chars (triplets!) to unicode strings"
      # EmojiData.unified_to_char('0030-FE0F-20E3').should eq("\u{0030}\u{FE0F}\u{20E3}")
