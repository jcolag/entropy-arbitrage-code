# frozen_string_literal: true

# Code for the citation inline tag
class ChartInlineTag < Liquid::Tag
  def initialize(tag_name, text, parse_context)
    super
    params = text.split '|'
    @chart_name = params[0]
    @chart_x = 740
    @chart_y = params[1]
    @chart_config = params[2]
  end

  def render(_context)
    cid = @chart_name
    cid.gsub!('-', '')

    return p <<HERE
<div width="#{@chart_x}" height="#{@chart_y}">
  <canvas id="#{@chart_name}" border="2px" width="#{@chart_x}" height="#{@chart_y}"></canvas>
</div>

<script>
  const ctx_#{cid} = document.getElementById('#{@chart_name}');
  new Chart(ctx_#{cid}, #{@chart_config});
</script>
HERE
  end
end
Liquid::Template.register_tag('chart', ChartInlineTag)
