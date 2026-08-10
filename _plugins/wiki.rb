# frozen_string_literal: true

# Code for the Wikipedia inline tag
class WikiInlineTag < Liquid::Tag
  def initialize(tag_name, text, parse_context)
    super
    @page, @text, @lang = parse text
  end

  def render(_context)
    "<a href='https://#{@lang}.wikipedia.org/wiki/#{@page}'>#{@text}</a>"
  end

  def parse(text)
    page, text, lang = text.split '|'

    lang ||= 'en'
    [CGI.escape(CGI.unescape(page)), text, lang.strip]
  end
end
Liquid::Template.register_tag('wiki', WikiInlineTag)
