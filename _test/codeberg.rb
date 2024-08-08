require 'liquid'
require 'tracer'
require_relative '../_plugins/codeberg.rb'

Tracer.on unless ENV['DEBUG'].nil?

repo = 'jcolag/basic-interpreter'
repo = ARGV[0] unless ARGV.empty?
context = Liquid::ParseContext.new
cht = CodebergInlineTag.send :new, 'codeberg', repo, context

puts cht.render(context)
Tracer.off

