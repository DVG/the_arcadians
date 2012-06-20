class ForumsController < ApplicationController
  
  filter_access_to :index, :show
  
  def index
    @forums = Forum.all
  end
  
  def show
    @forum = Forum.find(params[:id])
    @threads = @forum.threads
  end
end
