class PostsController < ApplicationController  
  def index
    @discussion = Discussion.find(params[:discussion_id])
    @posts = @discussion.posts
    @post = Post.new
  end
  
  def show
    @post = Post.find(params[:id])
  end

  def new
    @discussion = Discussion.find(params[:discussion_id])
    @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
    @discussion = @post.discussion
  end

  def create
    @post = Post.new(params[:post])
    @post.user = current_user
    @post.discussion = Discussion.find(params[:discussion_id])
    respond_to do |format|
      if @post.save!
        format.js
        format.html { redirect_to discussion_posts_path(@post.discussion), notice: 'Post was successfully created.' }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @post = Post.find(params[:id])
      if @post.update_attributes(params[:post])
        redirect_to discussion_posts_path(@post.discussion), notice: 'Post was successfully updated.'
      else
        render action: "edit"
      end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_url
  end
end
