require 'liquid'
require 'tracer'
require_relative '../_plugins/steno.rb'

Tracer.on unless ENV['DEBUG'].nil?

word = '#STKPWHRAO*EUFRPBLGTSDZ'
word = ARGV[0] unless ARGV.empty?
context = Liquid::ParseContext.new
ght = StenoInlineTag.send :new, 'steno', word, context

puts ght.render(context)

