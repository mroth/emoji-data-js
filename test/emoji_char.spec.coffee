require 'coffee-errors'

chai = require 'chai'
sinon = require 'sinon'
# using compiled JavaScript file here to be sure module works
EmojiChar = require '../lib/emoji_char.js'

expect = chai.expect
chai.use require 'sinon-chai'


describe "EmojiChar", ->

  describe ".new", ->
    before ->
      poop_json = '{"name":"PILE OF POO","unified":"1F4A9","variations":[],"docomo":"","au":"E4F5","softbank":"E05A","google":"FE4F4","image":"1f4a9.png","sheet_x":11,"sheet_y":19,"short_name":"hankey","short_names":["hankey","poop","shit"],"text":null}'
      @poop = new EmojiChar(JSON.parse poop_json)

    it "should create instance getters for all key-values in emoji.json, with blanks as nil", ->
      @poop.name.should.equal 'PILE OF POO'
      @poop.unified.should.equal '1F4A9'
      @poop.variations.should.deep.equal []
      @poop.docomo.should.equal ''
      @poop.au.should.equal 'E4F5'
      @poop.softbank.should.equal 'E05A'
      @poop.google.should.equal 'FE4F4'
      @poop.image.should.equal '1f4a9.png'
      @poop.sheet_x.should.equal 11
      @poop.sheet_y.should.equal 19
      @poop.short_name.should.equal 'hankey'
      @poop.short_names.should.deep.equal ["hankey","poop","shit"]
      expect(@poop.text).to.be.null


  context "instance methods", ->
    before ->
      @invader   = new EmojiChar({unified: '1F47E'})
      @usflag    = new EmojiChar({unified: '1F1FA-1F1F8'})
      @hourglass = new EmojiChar({unified: '231B', variations: ['231B-FE0F']})
      @cloud     = new EmojiChar({unified: '2601', variations: ['2601-FE0F']})

    describe "#to_s", ->
      it "should return the unicode char as string as default to_s"
        # @invader.to_s.should eq(@invader.char)

    describe "#char", ->
      it "should render as happy shiny unicode", ->
        @invader.char().should.equal "👾"

      it "should render as happy shiny unicode for doublebyte chars too", ->
        @usflag.char().should.equal "🇺🇸"

      it "should have a flag to output forced emoji variant char encoding if requested", ->
        @cloud.char(    {variant_encoding: false}).should.equal "\u2601"
        @cloud.char(    {variant_encoding:  true}).should.equal "\u2601\uFE0F"

      it "should fall back to normal encoding if no variant exists, even when requested"
        # @invader.char(  {variant_encoding: false}).should eq("\u{1F47E}")
        # @invader.char(  {variant_encoding:  true}).should eq("\u{1F47E}")

      it "should default to variant encoding for chars with a variant present"
        # @cloud.char.should eq("\u{2601}\u{FE0F}")
        # @hourglass.char.should eq("\u{231B}\u{FE0F}")


    describe "#chars", ->
      it "should return an array of all possible string render variations", ->
        @invader.chars().should.deep.equal ["👾"]
        @cloud.chars().should.deep.equal ["\u2601","\u2601\uFE0F"]

    describe "#is_doublebyte", ->
      it "should indicate when a character is doublebyte based on the unified ID", ->
        @usflag.is_doublebyte().should.be.true
        @invader.is_doublebyte().should.be.false

    describe "#has_variants", ->
      it "should indicate when a character has an alternate variant encoding", ->
        @hourglass.has_variants().should.be.true
        @usflag.has_variants().should.be.false

    describe "#variant", ->
      it "should return the most likely variant encoding ID representation for the char", ->
        @hourglass.variant().should.equal '231B-FE0F'

      it "should return null if no variant encoding for the char exists", ->
        expect(@usflag.variant()).to.be.null
