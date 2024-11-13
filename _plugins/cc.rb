# frozen_string_literal: true

require 'json'

# Code for the citation inline tag
class CcInlineTag < Liquid::Tag
  def initialize(tag_name, text, parse_context)
    super
    @text = text.strip.downcase
  end

  def render(_context)
    licenses = {
      '' => '&#xa9;',
      '0' => '&#x1f16d;&#x1f10d;',
      'by' => '&#x1f16d;&#x1f16f;',
      'by-nc' => '&#x1f16d;&#x1f16f;&#x1f10f;',
      'by-nc-nd' => '&#x1f16d;&#x1f16f;&#x1f10f;&#x229C;',
      'by-nc-sa' => '&#x1f16d;&#x1f16f;&#x1f10f;&#x1f10e;',
      'by-nd' => '&#x1f16d;&#x1f16f;&#x229C;',
      'by-sa' => '&#x1f16d;&#x1f16f;&#x1f10e;',
      'pd' => '&#x1f16d;&#x1f16e;'
    }
    license = licenses[@text]

    "<span class=\"license\" title=\"#{@text}\">#{license}</span>"
  end
end
Liquid::Template.register_tag('cc', CcInlineTag)
