class KeyInlineTag < Liquid::Tag
  def initialize(tag_name, text, parse_context)
    super
    @text = text
  end

  def render(context)
    return "<span class=\"kbd\">#{@text}</span>"
  end
end
Liquid::Template.register_tag('key', KeyInlineTag)
