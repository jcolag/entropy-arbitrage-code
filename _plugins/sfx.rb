# frozen_string_literal: true

# Code for the sound effect inline tag
class SfxInlineTag < Liquid::Tag
  def initialize(tag_name, text, parse_context)
    super
    @text = text
  end

  def render(_context)
    "&#9886;#{@text.strip}&#9887;"
  end
end
Liquid::Template.register_tag('sfx', SfxInlineTag)
