# frozen_string_literal: true

# Code for the line-chart inline tag
class LineChartInlineTag < Liquid::Tag
  def initialize(tag_name, text, parse_context)
    super
    @text = text
  end

  def render(_context)
    xaxis = ''
    yaxis = ''
    title, id, height, data_file, axes = params @text
    n = rand 100
    data_file = File.join '_posts', 'data', data_file
    data = File.read data_file
    xaxis = "xAxisID: 'xAxis'," if axes.include? 'x'
    yaxis = "yAxisID: 'yAxis'," if axes.include? 'y'
    "<canvas id='#{id}' width='740px' height='#{height}'></canvas>" \
      "<script type='text/javascript'>" \
      "var ctx#{n} = document.getElementById('#{id}').getContext('2d');" \
      "var labels#{n} = [...Array(#{data.lines.count + 1}).keys()];" \
      "new Chart(ctx#{n}, {" \
      "  type: 'line'," \
      "  data: {" \
      "    labels: labels#{n}," \
      "    datasets: [{" \
      "      label: '#{title}'," \
      "      data: [" +
      data.gsub("\n", ",\n") +
      + "      ]," \
      "      fill: true," \
      "      borderColor: '#49281b'," \
      "      fillColor: '#49281b20'," \
      "      tension: 0.0," \
      "      #{xaxis}#{yaxis}" \
      "    }]" \
      "  }," \
      "  options: {" \
      "    scales: {" \
      "      xAxis: {" \
      "        axis: 'x'," \
      "        beginAtZero: true," \
      "        ticks: {" \
      "          display: false," \
      "        }," \
      "      }," \
      "      yAxis: {" \
      "        axis: 'y'," \
      "        beginAtZero: true," \
      "        ticks: {" \
      "          display: false," \
      "        }," \
      "      }," \
      "    }" \
      "  }" \
      "});" \
      "</script>";
  end

  def params(input)
    parts = input.split '|'
    [parts[0].strip, parts[1].strip, parts[2].strip, parts[3].strip, parts[4].strip]
  end
end
Liquid::Template.register_tag('line_chart', LineChartInlineTag)
