# frozen_string_literal: true

# Code for the PlantUML Salt inline tag
class SaltBlockTag < Liquid::Block
  def initialize(tag_name, text, parse_context)
    super
    text = '1' if text.to_s.strip.empty?
    @opts = arg text
  end

  def arg(text)
    return {} unless text.is_a? String

    parts = text.split '|'
    { title: parts[0] }
  end

  def salt_to_svg(ui)
    output = ''
    Open3.popen3('plantuml', '-tsvg', '-pipe') do |stdin, stdout, stderr, wait_thr|
      stdin.write "@startsalt\n#{ui}\n@endsalt"
      stdin.close
      output = stdout.read
      stdout.close
      stderr.close
      raise 'PlantUML conversion failed' unless wait_thr.value.success?
    end

    output
  end

  def render(context)
    img = salt_to_svg super
    "<div class='mock-ui' title='#{@opts[:title]}'>\n#{img}\n</div>"
  end
end
Liquid::Template.register_tag('salt', SaltBlockTag)
