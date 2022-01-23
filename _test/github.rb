require 'liquid'
require 'tracer'
require_relative '../_plugins/github.rb'

repo = 'jcolag/dash'
repo = ARGV[0] unless ARGV.empty?
context = Liquid::ParseContext.new
ght = GithubInlineTag.send :new, 'github', repo, context

puts ght.render(context)

