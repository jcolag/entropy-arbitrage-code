# SPDX-FileCopyrightText: 2020 John Colagioia <john@colagioia.net>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

require 'liquid'
require 'tracer'
require_relative '../_plugins/archive.rb'

Tracer.on unless ENV['DEBUG'].nil?

file = 'VODO202YourFaceIsASaxophone'
file = ARGV[0] unless ARGV.empty?
context = Liquid::ParseContext.new
aht = ArchiveInlineTag.send :new, 'archive', file, context

puts aht.render(context)
Tracer.off

