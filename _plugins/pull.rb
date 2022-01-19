# frozen_string_literal: true

# Code for the pull quote inline tag
class PullInlineTag < Liquid::Tag
  def initialize(tag_name, text, parse_context)
    super
    @text = text
  end

  def render(_context)
    text, place = params @text
    "<aside class=\"pull-quote pull-quote-#{place}\">" \
      "#{text}</aside>"
  end

  def params(input)
    parts = input.split '|'
    [parts[0].strip, parts.length > 1 ? parts[1].strip : 'right']
  end
end
Liquid::Template.register_tag('pull', PullInlineTag)
