# frozen_string_literal: true

# Code for the citation inline tag
class SocialImageInlineTag < Liquid::Tag
  def initialize(tag_name, text, parse_context)
    super
    @text = text
  end

  def render(_context)
    url, description, sensitive, credit = params @text
    if credit.empty?
      return "<p class='no-image'><i class='fas fa-image'></i>" \
        " Image Not Shown: #{description}</p>"
    end

    css_class = "embedded#{sensitive ? ' sensitive' : ''}"
    "<figure class='external-image'><img alt='#{description}' " \
      "class='#{css_class}' src='#{url}' title='#{description}'>" \
      "<figcaption>#{description}<br>Image credit: #{credit}" \
      "</figcaption></figure>"
  end

  def params(input)
    parts = input.split '|'
    [parts[0].strip, CGI::escapeHTML(parts[1].strip),
      parts.length > 2 ? parts[2].strip == 'true' : false,
      parts.length > 3 ? CGI::escapeHTML(parts[3].strip) : '']
  end
end
Liquid::Template.register_tag('embed', SocialImageInlineTag)
