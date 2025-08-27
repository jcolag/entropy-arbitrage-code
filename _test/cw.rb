require 'liquid'
require 'tracer'
require_relative '../_plugins/cw.rb'

Tracer.on unless ENV['DEBUG'].nil?

warn = 'This *should* test **Markdown** and "smart-quotes..."'
warn = ARGV.join ' ' unless ARGV.empty?
context = Liquid::ParseContext.new
cw = ContentWarningTag.send :new, 'cw', warn, context

puts cw.render(context)
#Tracer.off
