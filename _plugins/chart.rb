# frozen_string_literal: true

# Code for the citation inline tag
class ChartInlineTag < Liquid::Tag
  def initialize(tag_name, text, parse_context)
    super
  end

  def render(_context)
    '<script src="/blog/assets/chart.js"></script>' \
      '<script>let ctx = null;let labels = null;' \
      '</script>';
  end
end
Liquid::Template.register_tag('chart', ChartInlineTag)
