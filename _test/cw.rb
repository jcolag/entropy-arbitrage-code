require 'jekyll'
require 'liquid'
require 'tracer'
require_relative '../_plugins/cw.rb'

Tracer.on unless ENV['DEBUG'].nil?

warn = 'This *should* test **Markdown** and "smart-quotes..."'
warn = ARGV.join ' ' unless ARGV.empty?
p_context = Liquid::ParseContext.new
cw = ContentWarningTag.send :new, 'cw', warn, p_context

context = Liquid::Context.new
context.registers[:site] = Jekyll::Site.new(Jekyll.configuration)
puts cw.render(context)
#Tracer.off
