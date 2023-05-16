# frozen_string_literal: true

require 'json'

# Code for the citation inline tag
class EmojiInlineTag < Liquid::Tag
  def initialize(tag_name, text, parse_context)
    super
    emoji_file = File.join '_plugins', 'emoji-en-US.json'
    @text = text.strip.downcase
    @emoji = load_json emoji_file
  end

  def render(_context)
    candidates = []

    @emoji.each do |k, v|
      candidates.push k if v.include? @text || v.include?(@text.gsub ' ', '_')
    end

    choice = candidates.sample 1
    "<span class=\"emoji\" title=\"#{@text}\">#{choice[0]}</span>"
  end

  def load_json(file)
    text = File.read file
    JSON.parse text
  end
end
Liquid::Template.register_tag('emoji', EmojiInlineTag)
