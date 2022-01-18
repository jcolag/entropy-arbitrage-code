require 'net/http'

class GithubInlineTag < Liquid::Tag
  def initialize(tag_name, text, parse_context)
    super
    @uri = URI("https://github.com/#{text.strip}/")
  end

  def render(context)
    imageUrl = ''
    imageAlt = ''
    title = ''
    url = ''
    Net::HTTP.start(@uri.host, @uri.port, :use_ssl => true) do |http|
      request = Net::HTTP::Get.new @uri
      response = http.request request
      lines = response
        .body
        .gsub('<', "\n<")
        .split("\n")
        .filter{|l| l.include? '="og:'}
      imageUrl = prop(lines, '="og:image"')
      imageAlt = prop(lines, '="og:image:alt"')
      title = prop(lines, '="og:title"')
      url = prop(lines, '="og:url"')
    end

    caption = title.split(':').shift.strip
    return "<a class='preview' href='#{url}'><span class='caption'>" +
      "<i class='fab fa-github'></i> #{caption}</span>" +
      "<img alt='#{imageAlt}' src='#{imageUrl}' title='#{title}'></a>"
  end
  
  def prop(lines, name)
    parts = lines.filter{|l| l.include? name}[0].split('"')
    idx = (parts[1].include? 'og:') ? 3 : 1
    return parts[idx]
  end
end
Liquid::Template.register_tag('github', GithubInlineTag)
