# frozen_string_literal: true

# Code for the keyboard inline tag
class XInlineTag < Liquid::Tag
  def initialize(tag_name, text, parse_context)
    super
    @text = text
  end

  def render(_context)
    "<span class=\"x\" title=\"née Twittr\">&#x1d54f;</span>"
  end
end
Liquid::Template.register_tag('x', XInlineTag)
