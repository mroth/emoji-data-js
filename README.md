# emoji-data-js

NodeJS library providing low level operations for dealing with Emoji
glyphs in the Unicode standard. :cool:

EmojiData.js is like a swiss-army knife for dealing with Emoji encoding issues.
If all you need to do is translate `:poop:` into :poop:, then there are plenty
of other libs out there that will probably do what you want.  But once you are
dealing with Emoji as a fundamental part of your application, and you start to
realize the nightmare of [doublebyte encoding][doublebyte] or
[variants][variant], then this library may be your new best friend.
:raised_hands:

EmojiData.js is written by the same author as the Ruby [emoji_data.rb][rb] gem,
which is used in production by [Emojitracker.com][emojitracker] to parse well
over 100M+ emoji glyphs daily. This version was written to provide all the same
functionality while taking advantage of the crazy speed of the V8 runtime
environment. :dizzy:

**WORK IN PROGRESS - NOT RELEASED JUST YET**

[![Build Status](https://travis-ci.org/mroth/emoji-data-js.svg?branch=master)](https://travis-ci.org/mroth/emoji-data-js)

[rb]: https://github.com/mroth/emoji_data.rb
[emojitracker]: http://www.emojitracker.com

## Installation
(Placeholder: won't work until this is released)

    npm install emoji-data

## Usage Examples

TODO

## Testing

    npm test

## License

[The MIT License (MIT)](LICENSE)
