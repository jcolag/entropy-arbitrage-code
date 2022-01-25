require 'liquid'
require 'tracer'
require_relative '../_plugins/github.rb'

Tracer.on unless ENV['DEBUG'].nil?

repo = 'jcolag/dash'
repo = ARGV[0] unless ARGV.empty?
context = Liquid::ParseContext.new
ght = GithubInlineTag.send :new, 'github', repo, context

puts ght.render(context)
Tracer.off

