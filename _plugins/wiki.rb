# frozen_string_literal: true

# Code for the Wikipedia inline tag
class WikiInlineTag < Liquid::Tag
  def initialize(tag_name, text, parse_context)
    super
    parts = text.split '|'
    @page = parts[0]
    @text = parts[1]
    @lang = parts.length > 2 ? parts[2] : 'en'
  end

  def render(_context)
    "<a href='https://#{@lang}.wikipedia.org/wiki/#{@page}'>#{@text}</a>"
  end
end
Liquid::Template.register_tag('wiki', WikiInlineTag)
