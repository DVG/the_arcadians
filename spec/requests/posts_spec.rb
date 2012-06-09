require 'spec_helper'

describe "Posts" do
  before :each do
    @forum = create(:forum)
    @post = create(:thread, forum: @forum)
    @reply = create(:reply, forum: @forum, thread: @post)
    @user = create(:user)
    visit new_user_session_path
    fill_in "user_username", with: @user.username
    fill_in "user_password", with: @user.password
    click_button 'Sign in'
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
  it 'shows the post title in the table' do
    visit forum_path(@forum)
    page.should have_link "#{@post.title}"
  end
  it 'shows the creator of the thread' do
    visit forum_path(@forum)
    page.should have_link "#{@post.user.username}"
  end
  it 'sets the current user as the posts user' do
    visit new_forum_post_path(@forum)
    fill_in "post_title", with: 'Megathread'
    fill_in "post_body", with: 'Sup dudes'
    click_button 'Create Post'
    post = Post.last
    post.user.should eq @user
    visit forum_path(@forum)
    page.should have_link "#{post.user.username}"
  end
  it 'shows the posts in a given thread' do
    visit view_thread_forum_post_path(@forum, @post)
    page.should have_selector "#post_#{@post.id}"
    page.should have_selector "#post_#{@reply.id}"
  end
end