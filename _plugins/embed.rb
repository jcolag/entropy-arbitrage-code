# frozen_string_literal: true

# Code for the citation inline tag
class SocialImageTag < Liquid::Tag
  def initialize(tag_name, text, parse_context)
    super
    @text = text
  end

  def render(_context)
    url, description, is_sensitive, credit = params @text
    return '' if credit.empty?

    css_class = "embedded#{is_sensitive ? ' sensitive' : ''}"
    "<a href='#{url}'><figure><img alt='#{description}' " \
      "class='#{css_class}' src='#{url} title='#{description}'>" \
      "<figcaption>#{credit}</figcaption></a>"
  end

  def params(input)
    parts = input.split '|'
    [parts[0].strip, parts[1].strip, parts.length > 2 ? parts[2].strip : false,
     parts.length > 3 ? parts[3].strip : '']
  end
end
Liquid::Template.register_tag('embed', SocialImageTag)
