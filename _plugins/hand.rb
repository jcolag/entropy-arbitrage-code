class HandWritingBlockTag < Liquid::Block
  def render(context)
    text = super.strip.gsub("\n", "\n<br>\n")
    "<div class='handwritten'>\n#{text}\n</div>"
  end
end
Liquid::Template.register_tag("hand", HandWritingBlockTag)

