# frozen_string_literal: true

# Code for the right-image inline tag
class ImgrInlineTag < Liquid::Tag
  def initialize(tag_name, text, parse_context)
    super
    @text = text
  end

  def render(_context)
    alt, url, title = params @text
    avif = "assets/#{url}.avif"
    url = "#{url}.avif" if File.exist? avif
    "<img alt=\"#{alt}\" class=\"image-right\" loading='lazy' " \
      "src=\"/blog/assets/#{url}\" title=\"#{title}\">"
  end

  def params(input)
    parts = input.split '|'
    [parts[0].strip, parts[1].strip, parts.length > 2 ? parts[2].strip : parts[0].strip]
  end
end
Liquid::Template.register_tag('imgr', ImgrInlineTag)
