# frozen_string_literal: true

# Code for the doughnut-chart inline tag
class DoughnutChartInlineTag < Liquid::Tag
  def initialize(tag_name, text, parse_context)
    super
    @text = text
  end

  def render(_context)
    xaxis = ''
    yaxis = ''
    title, id, data_file, color_file = params @text
    n = rand 100
    data_file = File.join '_posts', 'data', data_file
    color_file = File.join '_posts', 'data', color_file
    data = File.read data_file
    colors = File.read color_file
    "<canvas id='#{id}' width='740px' height='740px'></canvas>\n" \
      "<script type='text/javascript'>\n" \
      "var ctx#{n} = document.getElementById('#{id}').getContext('2d');\n" \
      "var labels#{n} = [...Array(#{data.lines.count + 1}).keys()];\n" \
      "new Chart(ctx#{n}, {\n" \
      "  type: 'doughnut',\n" \
      "  data: {\n" \
      "    datasets: [{\n" \
      "      label: '#{title}',\n" \
      "      hoverOffset: 25,\n" \
      "      data: [\n" +
      data.gsub("\n", ",\n") +
      + "    ],\n" \
      "      backgroundColor: [\n" +
      colors.gsub("\n", ",\n") +
      "      ],\n" \
      "    }],\n" \
      "  },\n" \
      "});\n" \
      "</script>";
  end

  def params(input)
    parts = input.split '|'
    [parts[0].strip, parts[1].strip, parts[2].strip, parts[3].strip]
  end
end
Liquid::Template.register_tag('doughnut_chart', DoughnutChartInlineTag)
