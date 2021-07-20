class ImgrInlineTag < Liquid::Tag
  def initialize(tag_name, text, parse_context)
    super
    @text = text
  end

  def render(context)
    alt, url, title = params @text
    return "<img alt=\"#{alt}\" class=\"image-right\" " \
      "src=\"/blog/assets/#{url}\" title=\"#{title}\">"
  end

  def params(input)
    parts = input.split '|'
    return parts[0].strip, parts[1].strip, parts[2].strip
  end
end
Liquid::Template.register_tag('imgr', ImgrInlineTag)
