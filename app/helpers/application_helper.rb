module ApplicationHelper
  def title(value = nil)
    if value
      content_for(:title, "#{value} - #{t(:blog_name)}")
    else
      content_for(:title, t(:blog_name))
    end

    content_for(:title)
  end

  def markdown_text(text)
    options = {
      filter_html: false,
      hard_wrap: true,
      link_attributes: { rel: "nofollow", target: "_blank" }
    }

    extensions = {
      autolink: true,
      highlight: true, # E.g., ==the words here are highlighted==
      underline: true, # E.g., _the words here are underlined_
      superscript: true,
      disable_indented_code_blocks: true,
      fenced_code_blocks: true,
      space_after_headers: true,
      tables: true
    }

    renderer = HTML.new(options)
    # renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    rendered_text = markdown.render(text || "").gsub("<img src=", "<img style=\"max-width: 100%\" src=")

    click_to_view_answer = params[:locale] == "zh" ? "点击查看答案" : "Click to view the answer"

    while rendered_text.scan(/markdetail/).size >= 2
      rendered_text.sub!("markdetail", "<details><summary>#{click_to_view_answer}</summary><p>").sub!("markdetail", "</p></details>")
    end

    rendered_text.html_safe
  end
end
