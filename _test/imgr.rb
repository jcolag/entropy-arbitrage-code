# SPDX-FileCopyrightText: 2020 John Colagioia <john@colagioia.net>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

require 'liquid'
require 'tracer'
require_relative '../_plugins/imgr.rb'

Tracer.on unless ENV['DEBUG'].nil?

alt = 'Alt text'
img = 'Caspar_David_Friedrich_-_Wanderer_above_the_sea_of_fog.png'
title = 'Title Text!'
alt = ARGV[0] unless ARGV.empty?
img = ARGV[1] unless ARGV.empty?
title = ARGV[2] unless ARGV.empty?
context = Liquid::ParseContext.new
imgr = ImgrInlineTag.send :new, 'imgr', "#{alt}|#{img}|#{title}", context

puts imgr.render(context)
#Tracer.off

