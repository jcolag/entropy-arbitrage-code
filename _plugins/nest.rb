# frozen_string_literal: true

# Code for the nest inline tag
class NestInlineTag < Liquid::Tag
  def initialize(tag_name, text, parse_context)
    super
    @post_id = text.strip
  end

  def render(_context)
    site = _context.registers[:site]
    post = site.posts.docs.find { |p| p.basename_without_ext == @post_id }
    converter = site.find_converter_instance ::Jekyll::Converters::Markdown
    layout = site.layouts[post.data['layout']]

    if post
      content = converter.convert post.content
      _context.stack do
        _context['page'] = Jekyll::Drops::DocumentDrop.new post
        _context['content'] = content
        Liquid::Template.parse(layout.content).render _context
      end
    else
      "No post <tt>#{@post_id}</tt> found!"
    end
  end
end
Liquid::Template.register_tag('nest', NestInlineTag)
