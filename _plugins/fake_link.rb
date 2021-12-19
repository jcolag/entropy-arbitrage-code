class FakeLinkInlineTag < Liquid::Tag
  def initialize(tag_name, text, parse_context)
    super
    @text = text
  end

  def render(context)
    action, message = params @text
    return "<a class='fake-link' onclick='alert(\"#{message}\");'>#{action}</a>"
  end

  def params(input)
    parts = input.split '|'
    return parts[0].strip, parts.length > 1 ? parts[1].strip : "This button doesn't actually do anything."
  end
end
Liquid::Template.register_tag('fake_link', FakeLinkInlineTag)
