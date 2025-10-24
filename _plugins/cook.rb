# frozen_string_literal: true

# Code for the handwriting inline tag
class CookBlockTag < Liquid::Block
  def initialize(tag_name, text, parse_context)
    super
    text = '1' if text.to_s.strip.empty?
    @opts = arg text
  end

  def arg(text)
    return {} unless text.is_a? String

    parts = text.split '|'
    { indent: parts[0], title: parts[1] }
  end

  def cook_to_md(recipe)
    output = ''

    Open3.popen3('cook', 'recipe', '-f', 'markdown') do |stdin, stdout, stderr, wait_thr|
      stdin.write recipe
      stdin.close
      output = stdout.read
      stdout.close
      stderr.close
      raise 'recipe conversion failed' unless wait_thr.value.success?
    end

    output
  end

  def md_to_html(markdown, converter)
    n = @opts[:indent].to_i + 1
    markdown.gsub!(/^# stdin/, '')
    markdown.gsub!(/%\b/, ' ')
    markdown.gsub!(/^#/, '#' * n)
    html = converter.convert(markdown)
    html.strip
  end

  def render(context)
    site = context.registers[:site]
    converter = site.find_converter_instance ::Jekyll::Converters::Markdown
    md = cook_to_md super
    recipe = md_to_html md, converter
    "<fieldset class='recipe'>\n<legend>\n#{@opts[:title]}\n</legend>\n#{recipe}\n</fieldset>"
  end
end
Liquid::Template.register_tag('cook', CookBlockTag)
