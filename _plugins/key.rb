# frozen_string_literal: true

# Code for the keyboard inline tag
class KeyInlineTag < Liquid::Tag
  def initialize(tag_name, text, parse_context)
    super
    @text = text
  end

  def render(_context)
    "<kbd class=\"kbd\">#{@text}</kbd>"
  end
end
Liquid::Template.register_tag('key', KeyInlineTag)
