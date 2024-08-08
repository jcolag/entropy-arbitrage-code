require 'liquid'
require 'tracer'
require_relative '../_plugins/emoji.rb'

Tracer.on unless ENV['DEBUG'].nil?

intent = 'pregnant man'
intent = ARGV.join ' ' unless ARGV.empty?
context = Liquid::ParseContext.new
ght = EmojiInlineTag.send :new, 'emoji', intent, context

puts ght.render(context)
Tracer.off
