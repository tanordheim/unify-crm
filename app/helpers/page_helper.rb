# encoding: utf-8
#

# Helpers for the Page model class.
module PageHelper

  # Render the body of a page.
  #
  # @param [ Page ] page The page to render.
  #
  # @return [ String ] The rendered page body.
  def page_body(page)

    @tagmap = {}
    @page = page
    body = page.body.dup

    # Convert the Markdown to HTML.
    body = BlueCloth.new(body).to_html

    # Extract the tags and replace them with placeholders.
    body = extract_tags(body)

    # Process the tags identified by extract_tags.
    body = process_tags(body)

    body.html_safe

  end

  private

  # Extract all wiki tags from the data and replace them with placeholders.
  # 
  # This code is copied from Githubs Gollum:
  # https://github.com/github/gollum/blob/master/lib/gollum/markup.rb
  def extract_tags(data)
    data.gsub!(/(.?)\[\[(.+?)\]\]([^\[]?)/m) do
      if $1 == "'" && $3 != "'"
        "[[#{$2}]]#{$3}"
      elsif $2.include?('][')
        if $2[0..4] == 'file:'
          pre = $1
          post = $3
          parts = $2.split('][')
          parts[0][0..4] = ""
          link = "#{parts[1]}|#{parts[0].sub(/\.org/,'')}"
          id = Digest::SHA1.hexdigest(link)
          @tagmap[id] = link
          "#{pre}#{id}#{post}"
        else
          $&
        end
      else
        id = Digest::SHA1.hexdigest($2)
        @tagmap[id] = $2
        "#{$1}#{id}#{$3}"
      end
    end

    data
  end

  # Process the tags in the tag map.
  def process_tags(data)
    @tagmap.each do |id, tag|
      data.gsub!(id, process_tag(tag))
    end
    data
  end

  # Process a single tag into its final HTML form.
  def process_tag(tag)
    process_page_link_tag(tag)
  end

  # Attempt to process the tag as a page link tag.
  def process_page_link_tag(tag)

    parts = tag.split('|')
    link_label, page_name = *parts.compact.map(&:strip)
    page_name = link_label if page_name.blank?

    if link_label =~ %r{^https?://} && page_name.nil?
      %{<a href="#{link_label}">#{link_label}</a>}
    else

      # Attempt to load the page being linked to.
      page = Page.where(:project_id => @page.project_id).where(:name => page_name).first

      href = if page.blank?
               new_project_page_path(@page.project, :page => { :name => page_name })
             else
               project_page_path(page.project, page)
             end

      presence = page.blank? ? 'absent' : 'present'
      %{<a class="internal #{presence}" href="#{href}">#{link_label}</a>}
    end

  end

end
