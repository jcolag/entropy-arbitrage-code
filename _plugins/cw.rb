# frozen_string_literal: true

# Code for the content warning inline tag
class ContentWarningTag < Liquid::Tag
  def initialize(tag_name, text, parse_context)
    super
    @text, kind, msg = params text
  end

  def render(context)
    site = context.registers[:site]
    converter = site.find_converter_instance(::Jekyll::Converters::Markdown)
    @html = converter.convert(@text)
    "<div class='content-warning'><i class='fas fa-exclamation-triangle'></i>" \
      " <b>Content Warning</b>:  #{@html}</div>"
  end

  def params(text)
    parts = text.split '|'
    parts << 'warning' if parts.length < 2
    parts << nil if parts.length < 3
    parts
  end
end
Liquid::Template.register_tag('cw', ContentWarningTag)
