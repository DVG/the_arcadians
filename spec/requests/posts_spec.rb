require 'spec_helper'

describe "Forums" do
  before :each do
    @forum = create(:forum)
    @post = create(:thread, forum: @forum)
  end
  it 'displays the posts for a given forum on the post index page' do
    visit forum_path(@forum)
    page.should have_selector('tr', :id => "thread_#{@post.id}")
  end
  it 'allows the user to create a new thread' do
    visit new_forum_post_path(@forum)
    expect {
    fill_in 'post_title', :with => 'New Thread'
    fill_in 'post_body', :with => 'Hello World'
    click_button 'Create Post'
    }.to change(Post, :count).by(1)
    current_path.should eq forum_post_path(@forum, Post.last)
  end
end