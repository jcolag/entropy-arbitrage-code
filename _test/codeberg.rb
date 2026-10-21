# SPDX-FileCopyrightText: 2020 John Colagioia <john@colagioia.net>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

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

