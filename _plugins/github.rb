# frozen_string_literal: true

require 'net/http'

# Code for the github inline tag
class GithubInlineTag < Liquid::Tag
  def initialize(tag_name, text, parse_context)
    super
    @uri = URI("https://github.com/#{text.strip}/")
  end

  def render(_context)
    image_alt = ''
    image_url = ''
    title = ''
    url = ''
    Net::HTTP.start(@uri.host, @uri.port, use_ssl: true) do |http|
      request = Net::HTTP::Get.new @uri
      response = http.request request
      lines = response
              .body
              .gsub('<', "\n<")
              .split("\n")
              .filter { |l| l.include? '="og:' }
      image_url = prop(lines, '="og:image"')
      image_alt = prop(lines, '="og:image:alt"')
      title = prop(lines, '="og:title"')
      url = prop(lines, '="og:url"')
    end

    caption = title.split(':').shift.strip
    "<a class='preview' href='#{url}'><span class='caption'>" \
      "<i class='fab fa-github'></i> #{caption}</span>" \
      "<img alt='#{image_alt}' src='#{image_url}' title='#{title}'></a>"
  end

  def prop(lines, name)
    parts = lines.filter { |l| l.include? name }[0].split('"')
    idx = parts[1].include?('og:') ? 3 : 1
    parts[idx]
  end
end
Liquid::Template.register_tag('github', GithubInlineTag)
