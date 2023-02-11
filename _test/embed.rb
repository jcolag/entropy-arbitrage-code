require 'liquid'
require 'tracer'
require_relative '../_plugins/embed.rb'

Tracer.on unless ENV['DEBUG'].nil?

param = 'https://www.futurity.org/wp/wp-content/uploads/2023/01/eating_disorders_boys_1600.jpg|A fork resting on a cloth napkin|false|by Sigmund (https://unsplash.com/@sigmund), made available under the terms of the Unsplash License'
param = ARGV[0] unless ARGV.empty?
context = Liquid::ParseContext.new
ght = SocialImageInlineTag.send :new, 'embed', param, context

puts ght.render(context)
Tracer.off

