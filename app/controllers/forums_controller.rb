class ForumsController < ApplicationController
  def index
    @forums = Forum.all
  end
end
