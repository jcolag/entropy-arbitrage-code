class HandWritingBlockTag < Liquid::Block
  def render(context)
    site = context.registers[:site]
    converter = site.find_converter_instance(::Jekyll::Converters::Markdown)
    html = converter.convert(super(context))
    text = html.strip
    "<div class='handwritten'>\n#{text}\n</div>"
  end
end
Liquid::Template.register_tag("hand", HandWritingBlockTag)

