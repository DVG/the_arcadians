require 'spec_helper'

describe "Posts" do
  before :each do
    # Each test will have a basic thread:
    # A user who creates the posts in @user who is logged in
    # A forum which holds the discussion in @forum
    # A discussion which holds the psots in @discussion
    # Two posts in the discussion in @post and @post_two
    @user = create(:user)
    @forum = create(:forum)
    @discussion = create(:discussion, forum: @forum, user: @user)
    @post = create(:post, discussion: @discussion, user: @user)
    @post_two = create(:post, discussion: @discussion)
    visit new_user_session_path
    fill_in "user_username", with: @user.username
    fill_in "user_password", with: @user.password
    click_button 'Sign in'
  end
  
  context "layout" do
    it 'displays the posts for a given forum on the post index page' do
      visit forum_discussions_path(@forum)
      page.should have_selector('li', :id => "discussion_#{@discussion.id}")
    end
    it 'shows a new post button on the post index page' do
      visit forum_discussions_path(@forum)
      page.should have_link "New Thread"
    end
    it 'shows the post title in the table' do
      visit forum_discussions_path(@forum)
      page.should have_link "#{@discussion.title}"
    end
  end
  
  context "Create new discussion" do
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
  end
  
  context 'replies' do
    it 'has a quick reply section' do
      visit discussion_posts_path(@discussion)
      page.should have_selector "div#quick_reply"
    end
    it 'allows a user to reply via the reply action' do
      visit discussion_posts_path(@discussion)
      click_link "Reply"
      fill_in 'post_body', :with => 'Avada Kedavra!'
      click_button "Post Reply"
      within "#post_#{@discussion.posts.last.id}" do
       page.should have_content 'Avada Kedavra!'
      end
    end
    it 'allows a user to make a quick reply' do
      visit discussion_posts_path(@discussion)
      fill_in "post_body", :with => "Quick Reply"
      click_button 'Post Reply'
      within "#post_#{@discussion.posts.last.id}" do
        page.should have_content 'Quick Reply'
      end
    end
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
    context 'Buttons' do
      it 'has a quote button'
      it 'has an edit button' do
        visit discussion_posts_path(@discussion)
        within "#post_#{@post.id}" do
          page.should have_link "Edit"
        end
      end
      it 'has a delete button' do
        visit discussion_posts_path(@discussion)
        within "#post_#{@post.id}" do
          page.should have_link "X"
        end
      end
      it 'has a report button'
    end
  end
  
  context 'Quote'
  
  context 'Edit'
  
  describe 'Delete', js: true do
    
    it 'destroys the post' do
      visit discussion_posts_path(@discussion)
      expect {
      within "#post_#{@post_two.id}" do
        click_link 'X'
      end
      #accept the alert
      alert = page.driver.browser.switch_to.alert
      alert.accept
      }.to change(Post, :count).by(-1)
    end #destroy the post
    
    it 'the discussion should remain intact' do
      visit discussion_posts_path(@discussion)
      within "#post_#{@post_two.id}" do
        click_link 'X'
      end
      #accept the alert
      alert = page.driver.browser.switch_to.alert
      alert.accept
      @discussion.should_not be_nil
    end # discussio should remain intact
    
    it 'should slide up the post' do
      visit discussion_posts_path(@discussion)
      within "#post_#{@post_two.id}" do
        click_link 'X'
      end
      #accept the alert
      alert = page.driver.browser.switch_to.alert
      alert.accept
      sleep 1
      find("#post_#{@post_two.id}").should_not be_visible
    end #should slide up the post
    
  end
  
  context 'Report'
end