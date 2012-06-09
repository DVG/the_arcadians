class PostsController < ApplicationController
  def index
    @forum = Forum.find(params[:forum_id])
    @threads = @forum.threads
  end
  
  def show
    @post = Post.find(params[:id])
  end

  def new
    @forum = Forum.find(params[:forum_id])
    @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def create
    @forum = Forum.find(params[:forum_id])
    @post = Post.new(params[:post])
    @post.forum = @forum
    @post.user = current_user
    if @post.save
      redirect_to forum_post_path(@forum, @post), notice: 'Post was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @post = Post.find(params[:id])
      if @post.update_attributes(params[:post])
        redirect_to @post, notice: 'Post was successfully updated.'
      else
        render action: "edit"
      end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_url
  end
  
  def view_thread
    @forum = Forum.find(params[:forum_id])
    @posts = Post.thread_posts(params[:id])
  end
end
