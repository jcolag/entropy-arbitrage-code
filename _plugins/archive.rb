# SPDX-FileCopyrightText: 2020 John Colagioia <john@colagioia.net>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

# frozen_string_literal: true

# Code for the pull quote inline tag
class ArchiveInlineTag < Liquid::Tag
  def initialize(tag_name, text, parse_context)
    super
    @text = text
  end

  def render(_context)
    "<iframe\n" \
    "  allowfullscreen\n" \
    "  frameborder=\"0\"\n" \
    "  height=\"555\"\n" \
    "  mozallowfullscreen=\"true\"\n" \
    "  src=\"https://archive.org/embed/#{@text}\"\n" \
    "  width=\"740\"\n" \
    "  webkitallowfullscreen=\"true\"\n" \
    ">\n" \
    "</iframe>"
  end
end
Liquid::Template.register_tag("archive", ArchiveInlineTag)
