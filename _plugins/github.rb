# frozen_string_literal: true

require 'net/http'
require 'yaml'

# Code for the github inline tag
class GithubInlineTag < Liquid::Tag
  def initialize(tag_name, text, parse_context)
    super
    @text = text
    @cache_file = File.join '.jekyll-cache', 'github.yml'
    @cache = load_cache @cache_file
  end

  def render(_context)
    repo = get_repo @cache_file, @cache, @text
    caption = repo['title'].split(':').shift.strip

    @cache = load_cache @cache_file
    @cache[@text] = repo
    save_yaml @cache_file, @cache
    fallback =
    image_alt = repo['image_alt'].force_encoding('UTF-8')
    image_url = repo['image_url'].force_encoding('UTF-8')
    title = repo['title'].force_encoding('UTF-8')

    "<a class='preview' href='#{repo['url']}'>" \
      "<span class='caption' title='#{caption}'>" \
      "<i class='fab fa-github'></i>" \
      " #{caption}" \
      "</span>" \
      "<img" \
      " alt='#{image_alt}'" \
      " class='github'" \
      " src='#{image_url}'" \
      " title='#{title}'" \
      ">" \
      "</a>"
  end

  def prop(lines, name)
    parts = lines.filter { |l| l.include? name }[0].split('"')
    idx = parts[1].include?('og:') ? 3 : 1
    parts[idx]
  end

  def get_repo(_file, cache, key)
    return cache[key] if cache.key? key

    uri = URI "https://github.com/#{key.strip}/"
    repo = {}

    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      request = Net::HTTP::Get.new uri
      response = http.request request
      repo = extract_from_head response.body
    end

    repo
  end

  def extract_from_head(html)
    repo = {}

    lines = html
            .gsub('<', "\n<")
            .split("\n")
            .filter { |l| l.include? '="og:' }
    repo['image_url'] = prop(lines, '="og:image"')
    repo['image_alt'] = prop(lines, '="og:image:alt"')
    repo['title'] = prop(lines, '="og:title"')
    repo['url'] = prop(lines, '="og:url"')
    repo
  end

  def load_cache(file)
    cache_yaml = File.read file
    list = YAML.safe_load cache_yaml
    cache = {}
    return cache if list.nil?

    list.each do |site|
      site.each_key { |key| cache[key] = site[key] }
    end

    cache
  end

  def save_yaml(file, cache)
    list = []

    cache.each_key do |key|
      o = {}
      o[key] = cache[key]
      list.push o
    end

    File.open(file, 'w') { |f| f.write list.to_yaml.gsub ' :', ' ' }
  end
end
Liquid::Template.register_tag('github', GithubInlineTag)
