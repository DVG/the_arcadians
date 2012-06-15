require 'spec_helper'

describe "Users" do
  context 'basic login' do
    before :each do
      @user = create(:user)
    end
    it 'should log the user in with their username instead of their email' do
      visit new_user_session_path
      page.should_not have_selector '#user_email'
      fill_in 'user_username', with: @user.username
      fill_in 'user_password', with: @user.password
      click_button 'Sign in'
      page.should have_content 'You have signed in successfully'
      current_path.should eq root_path
    end
  end
  context "guest" do
    it 'does not allow guests to make new threads'
    it 'does not show the quick reply section for a guest'
    it 'does not allow a guest to reply'
  end
  context 'registered' do
    before :each do
      @user = create(:user, role: create(:registered_role))
      @forum = create(:forum)
      visit new_user_session_path
      fill_in 'user_username', with: @user.username
      fill_in 'user_password', with: @user.password
      click_button 'Sign in'
    end
    it 'allows a registered user to make a new thread' do
      visit forum_discussions_path(@forum)
      click_link "New Thread"
      fill_in 'discussion_title', :with => 'New Post'
      fill_in 'post_body', :with => 'Hello World'
      click_button 'Create Post'
      within "#discussion_title" do
        page.should have_content "New Post"
      end
    end
    context 'replies' do
      before :each do
        @discussion = create(:discussion, forum: @forum, user: @user)
        @post = create(:post, discussion: @discussion, user: @user)
      end
      it 'allows a registered user to reply to existing threads' do
        visit discussion_posts_path(@discussion)
        click_link "Reply"
        fill_in 'post_body', :with => 'Avada Kedavra!'
        click_button "Post Reply"
        within "#post_#{@discussion.posts.last.id}" do
          page.should have_content 'Avada Kedavra!'
        end
      end
      it 'shows the quick reply section for a registered user' do
         visit discussion_posts_path(@discussion)
         page.should have_selector "div#quick_reply"
      end
      it 'allows a registered user to perform a quick reply' do
        visit discussion_posts_path(@discussion)
        fill_in "post_body", :with => "Quick Reply"
        click_button 'Post Reply'
        within "#post_#{@discussion.posts.last.id}" do
          page.should have_content 'Quick Reply'
        end
      end
    end
    context 'editing' do
      before :each do
        @discussion = create(:discussion, forum: @forum, user: @user)
        @post = create(:post, discussion: @discussion, user: @user)
      end
      it 'shows the edit link for a users own post' do
        visit discussion_posts_path(@discussion)
        within "#post_#{@post.id}" do
          page.should have_link "Edit"
        end
      end
      it 'takes the user to the edit form for their own post' do
        visit discussion_posts_path(@discussion)
        within "#post_#{@post.id}" do
          click_link "Edit"
        end
        current_path.should eq edit_discussion_post_path(@discussion, @post)
      end
      it 'updates the users post' do
        visit discussion_posts_path(@discussion)
        within "#post_#{@post.id}" do
          click_link "Edit"
        end
        fill_in 'post_body', with: 'A man said to the universe, Sir, I exist!'
        click_button 'Post Reply'
        page.should have_content 'A man said to the universe, Sir, I exist!'
      end
      it 'does not allow a registered user to edit another posters post'
    end
  end
  context 'admin' do
    it 'allows an admin to make a new thread'
    it 'allows an admin to reply to existing threads'
    it 'allows an admin to see the quick reply section'
    it 'allows an admin to edit their own post'
    it 'allows an admin to edit another posters post'
    it 'allows an admin to perform a quick reply'
  end
end