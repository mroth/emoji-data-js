require 'coffee-errors'

chai = require 'chai'
sinon = require 'sinon'
# using compiled JavaScript file here to be sure module works
emojiData = require '../lib/emoji-data.js'

expect = chai.expect
chai.use require 'sinon-chai'

describe 'emoji-data', ->
  it 'works', ->
    actual = emojiData 'World'
    expect(actual).to.eql 'Hello World'
