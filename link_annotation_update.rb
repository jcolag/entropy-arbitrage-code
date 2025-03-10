# frozen_string_literal: true

# SPDX-FileCopyrightText: 2025 John Colagioia <jcolag@colagioia.net>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

require 'yaml'

def get_codepoint(line)
  content_match = line.match(/content:\s*"([^"]*)"/)
  content_match[1] unless content_match.nil?
end

def get_color(line)
  color_match = line.match(/color:\s*(#[^;]*)/)
  color_match[1].strip.sub(/'/, '') unless color_match.nil?
end

def split_url_list(list, regex)
  a = list.select { |f| regex.match f } unless list.nil?
  b = list.reject { |f| regex.match f } unless list.nil?
  [a, b]
end

def color(list, code, color)
  list[0].include?(code) ? color : transparent
end

def process_icon(icon_name, sites)
  ld, urls = split_url_list sites[icon_name], /\([ld]*\)/
  shadow = nil
  unless ld.nil? || ld.empty?
    l = color ld, 'l', 'black'
    d = color ld, 'd', 'white'
    shadow = "  text-shadow: 1px 1px light-dark(#{l}, #{d}), -1px -1px light-dark(#{l}, #{d});\n"
  end
  [urls, shadow]
end

def process_all_icons(input_file, sites)
  content = nil
  icons = []
  shadow = nil
  urls = nil

  File.foreach input_file do |line|
    next unless line =~ /\.si-([^:]+)::before\s*\{/

    name = Regexp.last_match 1

    if name.include? '--color'
      icons << { content:, color: get_color(line), name:, shadow:, urls: }
    else
      content = get_codepoint line
      urls, shadow = process_icon name, sites
    end
  end

  icons
end

def print_css(icons)
  icons.each do |icon|
    next if icon[:urls].nil?

    selector = icon[:urls].sort.map { |url| "a[href*=\"#{url}\"]::after" }.join ",\n"
    puts "#{selector} {\n  color: #{icon[:color]};\n  content: '#{icon[:content]}';\n  " \
      "font-family: 'Simple Icons';\n#{icon[:shadow]}}"
  end
end

sites = YAML.load_file '_plugins/simpleicons.yml'
icons = process_all_icons ARGV[0], sites
print_css icons
