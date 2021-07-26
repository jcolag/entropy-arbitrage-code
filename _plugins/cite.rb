class CiteInlineTag < Liquid::Tag
  def initialize(tag_name, text, parse_context)
    super
    @text = text
  end

  def render(context)
    return "<figcaption class=\"quote-author\"><cite>#{@text}" \
      "</cite></figcaption>"
  end
end
Liquid::Template.register_tag('cite', CiteInlineTag)
