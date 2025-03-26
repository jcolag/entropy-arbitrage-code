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
      opts.on('-p', '--prefix FILE', 'The CSS class prefix') do |p|
        options.prefix = p
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
  content_match = line.match(/content:\s*["']([^"']*)["']/)
  content_match[1] unless content_match.nil?
end

def get_color(line)
  color_match = line.match(/color:\s*(#[^;]*)/)
  color_match[1].strip.sub(/'/, '') unless color_match.nil?
end

def split_url_list(icon)
  return if icon.nil?
  return unless icon['type'] == 'link'

  shadow = icon.key?('shadow') ? icon['shadow'] : nil
  [shadow, icon['urls']]
end

def color(str, code, color)
  str.include?(code) ? color : 'transparent'
end

def process_link(icon_name, sites)
  ld, urls = split_url_list sites[icon_name]
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
    next unless line =~ /\.#{prefix}-([^:]+):+before[^{]*\{/

    name = Regexp.last_match 1

    if name.include? '--color'
      color = get_color line
    else
      icons << { content:, color:, name:, shadow:, urls: } unless urls.nil?
      content = get_codepoint line
      urls, shadow = process_link name, sites
      languages << process_language(content, name, sites)
      color = nil
    end
  end

  [icons, languages]
end

def print_link_css(icons)
  icons.each do |icon|
    next if icon[:urls].nil?

    selector = icon[:urls].sort.map { |url| "a[href*=\"#{url}\"]::after" }.join ",\n"
    puts "#{selector} {\n  color: #{icon[:color]};\n  content: '#{icon[:content]}';\n  " \
      "font-family: 'Simple Icons';\n#{icon[:shadow]}}"
  end
end

def print_language_css(icons)
  icons.each do |icon|
    next if icon[:names].nil?

    selector = icon[:names].sort.map { |name| "pre.language-#{name}::after" }.join ",\n"
    puts "#{selector} {\n  content: '#{icon[:content]}';\n}"
  end
end

options = Options.parse ARGV
sites = YAML.load_file options.mapping
icons, languages = process_all_icons options.stylesheet, sites, options.prefix
print_link_css icons
print_language_css languages
