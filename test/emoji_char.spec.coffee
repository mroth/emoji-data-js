require 'coffee-errors'

chai = require 'chai'
sinon = require 'sinon'
# using compiled JavaScript file here to be sure module works
emojiData = require '../lib/emoji_char.js'

expect = chai.expect
chai.use require 'sinon-chai'


describe "EmojiChar", ->
  
  describe ".new", ->
    # before(:all) do
    #   poop_json = %q/{"name":"PILE OF POO","unified":"1F4A9","variations":[],"docomo":"","au":"E4F5","softbank":"E05A","google":"FE4F4","image":"1f4a9.png","sheet_x":11,"sheet_y":19,"short_name":"hankey","short_names":["hankey","poop","shit"],"text":null}/
    #   @poop = EmojiChar.new(JSON.parse poop_json)
    # end
    it "should create instance getters for all key-values in emoji.json, with blanks as nil"
      # @poop.name.should eq('PILE OF POO')
      # @poop.unified.should eq('1F4A9')
      # @poop.variations.should eq([])
      # @poop.docomo.should eq('')
      # @poop.au.should eq('E4F5')
      # @poop.softbank.should eq('E05A')
      # @poop.google.should eq('FE4F4')
      # @poop.image.should eq('1f4a9.png')
      # @poop.sheet_x.should eq(11)
      # @poop.sheet_y.should eq(19)
      # @poop.short_name.should eq('hankey')
      # @poop.short_names.should eq(["hankey","poop","shit"])
      # @poop.text.should eq(nil)


  context "instance methods", ->
    # before(:all) do
    #   @invader   = EmojiChar.new({'unified' => '1F47E'})
    #   @usflag    = EmojiChar.new({'unified' => '1F1FA-1F1F8'})
    #   @hourglass = EmojiChar.new({'unified' => '231B', 'variations' => ['231B-FE0F']})
    #   @cloud     = EmojiChar.new({'unified' => '2601', 'variations' => ['2601-FE0F']})
    # end

    describe "#to_s", ->
      it "should return the unicode char as string as default to_s"
        # @invader.to_s.should eq(@invader.char)

    describe "#char", ->
      it "should render as happy shiny unicode"
        # @invader.char.should eq("👾")

      it "should render as happy shiny unicode for doublebyte chars too"
        # @usflag.char.should eq("🇺🇸")

      it "should have a flag to output forced emoji variant char encoding if requested"
        # @cloud.char(    {variant_encoding: false}).should eq("\u{2601}")
        # @cloud.char(    {variant_encoding:  true}).should eq("\u{2601}\u{FE0F}")
        # @invader.char(  {variant_encoding: false}).should eq("\u{1F47E}")
        # @invader.char(  {variant_encoding:  true}).should eq("\u{1F47E}")

      it "should default to variant encoding for chars with a variant present"
        # @cloud.char.should eq("\u{2601}\u{FE0F}")
        # @hourglass.char.should eq("\u{231B}\u{FE0F}")


    describe "#chars", ->
      it "should return an array of all possible string render variations"
        # @invader.chars.should eq(["\u{1F47E}"])
        # @cloud.chars.should   eq(["\u{2601}","\u{2601}\u{FE0F}"])


    describe "#doublebyte?", ->
      it "should indicate when a character is doublebyte based on the unified ID"
        # @usflag.doublebyte?.should be_true
        # @invader.doublebyte?.should be_false


    describe "#variant?", ->
      it "should indicate when a character has an alternate variant encoding"
        # @hourglass.variant?.should be_true
        # @usflag.variant?.should be_false


    describe "#variant", ->
      it "should return the most likely variant encoding ID representation for the char"
        # @hourglass.variant.should eq('231B-FE0F')

      it "should return nil if no variant encoding for the char exists"
        # @usflag.variant.should be_nil
