# frozen_string_literal: true

# SPDX-FileCopyrightText: 2025 John Colagioia <jcolag@colagioia.net>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

require 'optparse'
require 'ostruct'
require 'yaml'

# Class to process command-line arguments
class Options
  def self.parse(args)
    options = OpenStruct.new

    opt_parser = OptionParser.new do |opts|
      opts.banner = 'Usage:  link_annotation_update.rb [options]'
      opts.separator 'Specific options:'
      opts.on('-m', '--mapping FILE', 'The YAML file mapping names to metadata') do |m|
        options.mapping = m
      end
      opts.on('-s', '--stylesheet FILE', 'The CSS file for the icon font to analyze') do |c|
        options.stylesheet = c
      end
    end

    opt_parser.parse!(args)
    options
  end
end

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

def process_language(content, icon_name, sites)
  lang = sites[icon_name]

  return { names: nil } if lang.nil? || lang['type'] != 'language'

  { content:, name: icon_name, names: lang['names'] }
end

def process_all_icons(input_file, sites, prefix)
  content = nil
  icons = []
  languages = []
  shadow = nil
  urls = nil
  color = nil

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
