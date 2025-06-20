# frozen_string_literal: true

# Code for the github inline tag
class StenoInlineTag < Liquid::Tag
  def initialize(tag_name, text, parse_context)
    super
    @text = text
    @keys = get_keys text
    @image = File.read File.join('_plugins', 'steno-keyboard.svg')
    @nucleus = false
  end

  def get_keys(word)
    keys = []

    word.chars.each do |c|
      keys << class_from_char(c)
    end

    keys
  end

  def class_from_char(char)
    vowels = %w[A E O U - *]

    @nucleus = true if vowels.include? char
    if char == '*'
      'star'
    elsif char == '-'
      '~'
    elsif char == '#'
      'num'
    elsif @nucleus && !vowels.include?(char)
      "-#{char}"
    else
      char
    end
  end

  def render(_context)
    @image.gsub! 'nothing', @text unless @text.strip.empty?
    @keys.each do |k|
      @image.sub! "steno-key-#{k}", "steno-key-#{k} pressed"
    end
    @image
  end
end
Liquid::Template.register_tag('steno', StenoInlineTag)
