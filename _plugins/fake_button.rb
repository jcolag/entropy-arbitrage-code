# frozen_string_literal: true

# Code for the fake button inline tag
class FakeButtonInlineTag < Liquid::Tag
  def initialize(tag_name, text, parse_context)
    super
    @text = text
  end

  def render(_context)
    action, message = params @text
    "<button class='fake-button' onclick='alert(\"#{message}\");'>#{action}</button>"
  end

  def params(input)
    parts = input.split '|'
    [parts[0].strip, parts.length > 1 ? parts[1].strip : "This button doesn't actually do anything."]
  end
end
Liquid::Template.register_tag('fake_button', FakeButtonInlineTag)
