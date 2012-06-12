require 'spec_helper'

describe "Posts" do
  before :each do
    @forum = create(:forum)
    @post = create(:discussion, forum: @forum)
    @reply = create(:post, discussion: @discussion)
    @reply_two = create(:post, discussion: @discussion)
    @user = create(:user)
    visit new_user_session_path
    fill_in "user_username", with: @user.username
    fill_in "user_password", with: @user.password
    click_button 'Sign in'
  end
  it 'displays the posts for a given forum on the post index page' do
    visit forum_discussions_path(@forum)
    page.should have_selector('li', :id => "discussion_#{@post.id}")
  end
  it 'shows a new post button on the post index page' do
    visit forum_discussions_path(@forum)
    page.should have_link "New Thread"
  end
  it 'shows the post title in the table' do
    visit forum_discussions_path(@forum)
    page.should have_link "#{@post.title}"
  end
  it 'allows the user to make a post' do
    visit forum_discussions_path(@forum)
    click_link "New Thread"
    fill_in 'discussion_title', :with => 'New Post'
    fill_in 'discussion_post_body', :with => 'Hello World'
    click_button 'Create Post'
    discussion = Discussion.last
    post = discussion.posts.first
    discussion.title.should eq 'New Post'
    post.body.should eq 'Hello World'
    post.discussion.should eq discussion
    post.forum.should eq @forum 
  end
  it 'redirects the user to the new thread' do
    visit forum_discussions_path(@forum)
    click_link "New Thread"
    fill_in 'discussion_title', :with => 'New Post'
    fill_in 'discussion_post_body', :with => 'Hello World'
    click_button 'Create Post'
    current_path.should eq discussion_posts_path(Discussion.last)
  end
  it 'should display the post on the discussion posts index after posting' do
    visit forum_discussions_path(@forum)
    click_link "New Thread"
    fill_in 'discussion_title', :with => 'New Post'
    fill_in 'discussion_post_body', :with => 'Hello World'
    click_button 'Create Post'
    discussion = Discussion.last
    page.should have_selector "#post_#{discussion.posts.first.id}"
    within "#post_#{discussion.posts.first.id}" do
      page.should have_content 'Hello World'
    end
  end
  context 'replies' do
    it 'has a quick reply section'
    it 'allows a user to reply via the reply action'
    it 'allows a user to make a quick reply'
  end
  context 'pagination' do
    it 'displays 50 posts per page'
    it 'redirects the user to the last page after a reply is made'
  end
  context 'Post Details' do
    it 'displays the user who made the post'
    it 'displays the user who made the post\'s avatar'
    context 'Registered User' do
      it 'does not display a role badge'
    end
    context 'Moderator' do
      it 'displays a badge titled \'Moderator\' under the user\'s name'
    end
    context 'Admin' do
      it 'displays a badge titled \'Admin\' under the user\'s name'
    end
    context 'Jailed' do
      it 'displays a badge titled \'Jailed\' under the user\'s name'
    end
  end
  context 'Quote'
  context 'Edit'
  context 'Delete'
  context 'Report'
end