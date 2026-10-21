# SPDX-FileCopyrightText: 2020 John Colagioia <john@colagioia.net>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

# frozen_string_literal: true

# Code for the citation inline tag
class CiteInlineTag < Liquid::Tag
  def initialize(tag_name, text, parse_context)
    super
    @text = text
  end

  def render(_context)
    "<figcaption class=\"quote-author\"><cite>#{@text}" \
      '</cite></figcaption>'
  end
end
Liquid::Template.register_tag('cite', CiteInlineTag)
