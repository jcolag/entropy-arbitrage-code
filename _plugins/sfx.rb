class SfxInlineTag < Liquid::Tag
  def initialize(tag_name, text, parse_context)
    super
    @text = text
  end

  def render(context)
    return "&#9886;#{@text.strip}&#9887;"
  end
end
Liquid::Template.register_tag('sfx', SfxInlineTag)
