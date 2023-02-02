# frozen_string_literal: true

# Code for the citation inline tag
class ContentWarningTag < Liquid::Tag
  def initialize(tag_name, text, parse_context)
    super
    @text = text
  end

  def render(_context)
    "<p class='content-warning'><i class='fas fa-exclamation-triangle'>" \
      "</i> <b>Content Warning</b>:  #{@text}</p>"
  end
end
Liquid::Template.register_tag('cw', ContentWarningTag)
