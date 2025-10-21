# frozen_string_literal: true

# Code for the pull quote inline tag
class PullInlineTag < Liquid::Tag
  def initialize(tag_name, text, parse_context)
    super
    @text = text
  end

  def render(context)
    site = context.registers[:site]
    converter = site.find_converter_instance ::Jekyll::Converters::Markdown
    text, place = params @text
    text = converter.convert text
    "<aside class=\"pull-quote pull-quote-#{place}\">" \
      "#{text}</aside>"
  end

  def params(input)
    parts = input.split '|'
    [parts[0].strip, parts.length > 1 ? parts[1].strip : 'right']
  end
end
Liquid::Template.register_tag('pull', PullInlineTag)
