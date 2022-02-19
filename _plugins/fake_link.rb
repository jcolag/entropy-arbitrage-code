# frozen_string_literal: true

# Code for the fake link inline tag
class FakeLinkInlineTag < Liquid::Tag
  def initialize(tag_name, text, parse_context)
    super
    @text = text
  end

  def render(_context)
    action, message = params @text
    "<a class='fake-link' onclick='alert(\"#{message}\");'>#{action}</a>"
  end

  def params(input)
    parts = input.split '|'
    [parts[0].strip, parts.length > 1 ? parts[1].strip : "This link doesn't actually go anywhere."]
  end
end
Liquid::Template.register_tag('fake_link', FakeLinkInlineTag)
