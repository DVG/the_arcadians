module PostsHelper
  
  def decode_html(html)
    coder = HTMLEntities.new
    coder.decode(html)
  end
end
