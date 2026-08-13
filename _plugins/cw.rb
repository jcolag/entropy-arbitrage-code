# frozen_string_literal: true

# Code for the content warning inline tag
class ContentWarningTag < Liquid::Tag
  def initialize(tag_name, text, parse_context)
    super
    @text, kind, msg = params text
    @klass, @icon, @msg = specify kind, msg
  end

  def render(context)
    site = context.registers[:site]
    converter = site.find_converter_instance(::Jekyll::Converters::Markdown)
    html = converter.convert(@text)
    "<div class='#{@klass}'><i class='#{@icon}'></i>" \
      " <b>#{@msg}</b>:  #{html}</div>"
  end

  def params(text)
    parts = text.split '|'
    parts << 'warning' if parts.length < 2
    parts << nil if parts.length < 3
    parts
  end

  def specify(kind, msg)
    case kind.strip
    when 'info'
      klass, icon, message = info
    when 'warning'
      klass, icon, message = warn
    when 'question'
      klass, icon, message = question
    else
      klass, icon, message = misc
    end
    message = msg if msg
    [klass, icon, message]
  end

  def info
    ['content-info', 'fas fa-info-circle', 'Information']
  end

  def misc
    ['content-box', 'fas fa-square-full', 'Something']
  end

  def question
    ['content-question', 'far fa-question-circle', 'Question']
  end

  def warn
    ['content-warning', 'fas fa-exclamation-triangle', 'Content Warning']
  end
end
Liquid::Template.register_tag('cw', ContentWarningTag)
