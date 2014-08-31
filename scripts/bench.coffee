Benchmark = require('benchmark')
EmojiData = require('../lib/emoji_data.js')
EmojiChar = EmojiData.EmojiChar
_ = {}
_.str = require('underscore.string')

suites = []

s0 = "I liek to eat cake oh so very much cake eating is nice!! #cake #food"
s1 = "🚀"
s2 = "flying on my 🚀 to visit the 👾 people."
s3 = "first a \u0023\uFE0F\u20E3 then a 🚀"

suite = new Benchmark.Suite("Scanner")
suite
  .add "scan(s0)", -> EmojiData.scan(s0)
  .add "scan(s1)", -> EmojiData.scan(s1)
  .add "scan(s2)", -> EmojiData.scan(s2)
  .add "scan(s3)", -> EmojiData.scan(s3)
suites.push(suite)

suite = new Benchmark.Suite("EmojiData")
suite
  .add "all",                       -> EmojiData.all()
  .add "all_doublebyte",            -> EmojiData.all_doublebyte()
  .add "all_with_variants",         -> EmojiData.all_with_variants()
  .add "from_unified",              -> EmojiData.from_unified("1F680")
  .add "chars",                     -> EmojiData.chars()
  .add "codepoints",                -> EmojiData.codepoints()
  .add "find_by_name - many",       -> EmojiData.find_by_name("tree")
  .add "find_by_name - none",       -> EmojiData.find_by_name("zzzz")
  .add "find_by_short_name - many", -> EmojiData.find_by_short_name("MOON")
  .add "find_by_short_name - none", -> EmojiData.find_by_short_name("zzzz")
  .add "char_to_unified - single",  -> EmojiData.char_to_unified("🚀")
  .add "char_to_unified - double",  -> EmojiData.char_to_unified("\u2601\uFE0F")
  .add "unified_to_char - single",  -> EmojiData.unified_to_char("1F47E")
  .add "unified_to_char - double",  -> EmojiData.unified_to_char("2764-fe0f")
  .add "unified_to_char - triple",  -> EmojiData.unified_to_char("0030-FE0F-20E3")
suites.push(suite)

invader   = new EmojiChar({unified: '1F47E'})
usflag    = new EmojiChar({unified: '1F1FA-1F1F8'})
hourglass = new EmojiChar({unified: '231B', variations: ['231B-FE0F']})
cloud     = new EmojiChar({unified: '2601', variations: ['2601-FE0F']})

suite = new Benchmark.Suite("EmojiChar")
suite
  .add "render - single",  -> invader.render()
  .add "render - double",  -> usflag.render()
  .add "render - variant", -> cloud.render({variant_encoding: true})
  .add "chars",            -> cloud.chars()
  .add "is_doublebyte",    -> invader.is_doublebyte()
  .add "has_variants",     -> invader.has_variants()
  .add "variant",          -> invader.variant()
suites.push(suite)

micros = (hz) -> (1000000 / hz)
formatResult = (suitename, r) ->
  _.str.sprintf(
    "%-45s %10u   %.2f µs/op",
    "#{suitename}.#{r.name}", r.count, micros(r.hz)
  )

Benchmark.forEach(suites, (suite) ->
  results = suite.run()
  results.sort( (a,b) -> b.hz - a.hz )
  console.log ""
  Benchmark.forEach(results, (r) ->
    console.log formatResult(results.name, r)
  )
)
