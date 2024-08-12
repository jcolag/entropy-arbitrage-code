# frozen_string_literal: true

Jekyll::Hooks.register [:posts, :pages], :pre_render do |doc|
  if doc.extname == '.md' || doc.extname == '.markdown'
    doc.content = doc.content.gsub(/!\[([^\]]*)\]\(([^ )]+)(?:\s+"([^"]*)")?\)/) do |match|
      alt_text = Regexp.last_match 1
      src = Regexp.last_match 2
      title_text = Regexp.last_match 3
      avif_src = src + '.avif'
      avif_path = avif_src.sub /^\/blog/, '_site'

      if File.exist? avif_path
        "![#{alt_text}](#{avif_src} \"#{title_text}\")"
      else
        match
      end
    end

    if doc.data['thumbnail']
      original_thumb = doc.data['thumbnail']
      avif_thumb = original_thumb + '.avif'
      avif_path = avif_thumb.sub /^\/blog/, '_site'

      if File.exist?(avif_path)
        doc.data['thumbnail'] = avif_thumb
      end
    end
  end
end
