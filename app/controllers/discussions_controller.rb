class DiscussionsController < ApplicationController
  def index
    @forum = Forum.find(params[:forum_id])
    @discussions = @forum.discussions
  end
  
  def new
    @forum = Forum.find(params[:forum_id])
    @discussion = Discussion.new
    @discussion.posts << Post.new
  end
  
  def create
    @forum = Forum.find(params[:forum_id])
    @discussion = Discussion.new do |d|
      d.title = params[:discussion][:title]
      d.forum = @forum
      post = Post.new
      post.body = params[:discussion][:post][:body]
      post.user = current_user
      d.posts << post
    end
    if @discussion.save
      redirect_to discussion_posts_path(@discussion), notice: 'Post was successfully created.'
    else
      render action: "new"
    end
  end
end
