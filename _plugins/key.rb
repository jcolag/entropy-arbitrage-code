# SPDX-FileCopyrightText: 2020 John Colagioia <john@colagioia.net>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

# frozen_string_literal: true

# Code for the keyboard inline tag
class KeyInlineTag < Liquid::Tag
  def initialize(tag_name, text, parse_context)
    super
    @text = text.strip
  end

  def render(_context)
    "<kbd class=\"kbd\">#{@text}</kbd>"
  end
end
Liquid::Template.register_tag('key', KeyInlineTag)
