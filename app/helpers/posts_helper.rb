module PostsHelper
  def decode_html(text)
    coder = HTMLEntities.new
    coder.decode(text)
  end
end
