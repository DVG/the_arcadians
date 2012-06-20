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
  
  # Guest are unregistered or unlogged in users. They can see the threads, but cannot participate without registering
  context "guest" do
    before :each do
      @forum = create(:forum)
      @discussion = create(:discussion)
      @post = create(:post, discussion: @discussion)
    end
    
    context 'Create' do
    
      describe 'Threads' do
        it 'does not show a new thread button for a guest' do
          visit forum_discussions_path(@discussion)
          page.should_not have_link 'New Thread'
        end # it
        
        it 'should not be able to go to the new thread page' do
          visit new_forum_discussion_path(@forum)
          current_path.should eq root_path
          page.should have_content "Sorry, you not allowed to access that page."
        end # i
      end #threads
    
      context 'Replies' do
        describe 'Quick Reply' do
          it 'does not show the quick reply section for a guest' do
            visit discussion_posts_path(@discussion)
            page.should_not have_selector "div#quick_reply"
          end
        end #quick reply
        describe 'Normal Reply' do
          it 'does not allow a guest to reply' do
            visit new_discussion_post_path(@discussion)
            current_path.should eq root_path
            page.should have_content "Sorry, you not allowed to access that page."
          end #it
        end #normal reply
      end #replies
      
    end #create
    
    context 'read' do
      it 'should be able to access the forums page' do
        visit forums_path
        page.should_not have_content "Sorry, you not allowed to access that page."
      end
      it 'should be able to view the discussions on a given forum' do
        visit forum_discussions_path(@forum)
        current_path.should eq forum_discussions_path(@forum)
        page.should_not have_content "Sorry, you not allowed to access that page."
      end
      it 'should be able to view the posts on a given discussion' do
        visit discussion_posts_path (@discussion)
        current_path.should eq discussion_posts_path (@discussion)
        page.should_not have_content "Sorry, you not allowed to access that page."
      end
    end
    
    describe 'update' do
      it 'should not be able to edit a post' do
        visit edit_discussion_post_path(@discussion, @post)
        current_path.should eq root_path
        page.should have_content "Sorry, you not allowed to access that page."
      end
      it 'should not see the edit link' do
       visit discussion_posts_path(@discussion)
        within "#post_#{@post.id}" do
          page.should_not have_link 'Edit'
        end #within
      end #it
    end #describe
    
    describe 'delete' do
      # it 'should not be able to delete a post' deleting the post is handled in the controller spec
      it 'should not see a delete button on a post' do
        visit discussion_posts_path(@discussion)
        within "#post_#{@post.id}" do
          page.should_not have_link 'X'
        end #within
      end
    end #describe
    
  end #guest
  
  context 'registered' do
    before :each do
      @user = create(:user, role: create(:registered_role))
      @forum = create(:forum)
      @discussion = create(:discussion, user: @user)
      @post = create(:post, discussion: @discussion, user: @user)
      visit new_user_session_path
      fill_in 'user_username', with: @user.username
      fill_in 'user_password', with: @user.password
      click_button 'Sign in'
    end # before
    context 'create' do
      context 'threads' do
        it 'allows a registered user to make a new thread' do
          visit forum_discussions_path(@forum)
          click_link "New Thread"
          fill_in 'discussion_title', :with => 'New Post'
          fill_in 'post_body', :with => 'Hello World'
          click_button 'Create Post'
          within "#discussion_title" do
            page.should have_content "New Post"
          end # within
        end # it
      end
      context 'replies' do
        it 'shows the quick reply section for the registered user' do
          visit discussion_posts_path(@discussion)
          page.should have_selector "div#quick_reply"
        end # it
        it 'allows the user to make a quick reply' do
          visit discussion_posts_path(@discussion)
          fill_in 'post_body', with: "Hi there, I'm a quick reply"
          click_button 'Post Reply'
          page.should have_content "Hi there, I'm a quick reply"
        end # it
        it 'allows the user to make a normal reply' do
          visit new_discussion_post_path(@discussion)
          fill_in 'post_body', with: "Hi there, I'm a normal reply"
          click_button 'Post Reply'
          page.should have_content "Hi there, I'm a normal reply"
        end # it
      end
    end
    it 'allows a registered user to reply to existing threads' do
       visit discussion_posts_path(@discussion)
       click_link "Reply"
       fill_in 'post_body', :with => 'Avada Kedavra!'
       click_button "Post Reply"
       within "#post_#{@discussion.posts.last.id}" do
         page.should have_content 'Avada Kedavra!'
       end #within
     end # it
     it 'shows the quick reply section for a registered user' do
        visit discussion_posts_path(@discussion)
        page.should have_selector "div#quick_reply"
     end # it
     it 'allows a registered user to perform a quick reply' do
       visit discussion_posts_path(@discussion)
       fill_in "post_body", :with => "Quick Reply"
       click_button 'Post Reply'
       within "#post_#{@discussion.posts.last.id}" do
         page.should have_content 'Quick Reply'
       end # within
     end # it
    context 'read'
    context 'update' do
      it 'shows the edit link for a users own post' do
        visit discussion_posts_path(@discussion)
        within "#post_#{@post.id}" do
          page.should have_link "Edit"
        end # within
      end # it
      it 'takes the user to the edit form for their own post' do
        visit discussion_posts_path(@discussion)
        within "#post_#{@post.id}" do
          click_link "Edit"
        end # within
        current_path.should eq edit_discussion_post_path(@discussion, @post)
      end # it
      it 'updates the users post' do
        visit discussion_posts_path(@discussion)
        within "#post_#{@post.id}" do
          click_link "Edit"
        end # within
        fill_in 'post_body', with: 'A man said to the universe, Sir, I exist!'
        click_button 'Post Reply'
        page.should have_content 'A man said to the universe, Sir, I exist!'
      end # it
      it 'does not show the edit link for another user\'s post' do
        another_post = create(:post, discussion: @discussion)
        visit discussion_posts_path(@discussion)
        within "#post_#{another_post.id}" do
          page.should_not have_link "Edit"
        end
      end
      it 'does not allow a registered user to edit another posters post' do
        another_post = create(:post, discussion: @discussion)
        visit edit_discussion_post_path(@discussion, another_post)
        current_path.should eq root_path
        page.should have_content "Sorry, you not allowed to access that page."
      end
    end
    
    context 'delete' do
      it 'should have a delete link for their own post' do
        visit discussion_posts_path(@discussion)
        within "#post_#{@post.id}" do
          page.should have_link "X"
        end # within
      end
      it 'should not have a delete link for another users post' do
        another_post = create(:post, forum: @forum, discussion: @discussion)
        visit discussion_posts_path(@discussion)
         within "#post_#{another_post.id}" do
            page.should_not have_link "X"
          end # within
      end
      it 'should be able to delete their own post' do
        expect {
          visit discussion_posts_path(@discussion)
          within "#post_#{@post.id}" do
            click_link "X"
          end # within
          page.should_not have_selector "#post_#{@post.id}"
        }.to change(Post, :count).by(-1)
      end
    end
    
  end # registered
  
  
  context 'admin' do
    before :each do
      @user = create(:user, role: create(:admin_role))
      @forum = create(:forum)
      @discussion = create(:discussion, user: @user)
      @post = create(:post, discussion: @discussion, user: @user)
      visit new_user_session_path
      fill_in 'user_username', with: @user.username
      fill_in 'user_password', with: @user.password
      click_button 'Sign in'
    end
    it 'allows an admin to make a new thread' do
      visit forum_discussions_path(@forum)
       click_link "New Thread"
       fill_in 'discussion_title', :with => 'New Post'
       fill_in 'post_body', :with => 'Hello World'
       click_button 'Create Post'
       within "#discussion_title" do
         page.should have_content "New Post"
       end # within
    end
    it 'allows an admin to reply to existing threads' do
      visit discussion_posts_path(@discussion)
       click_link "Reply"
       fill_in 'post_body', :with => 'Avada Kedavra!'
       click_button "Post Reply"
       within "#post_#{@discussion.posts.last.id}" do
         page.should have_content 'Avada Kedavra!'
       end #within
    end
    it 'allows an admin to see the quick reply section' do
      visit discussion_posts_path(@discussion)
      page.should have_selector "div#quick_reply"
    end
    it 'shows the edit button for an admin\'s own post' do
      visit discussion_posts_path(@discussion)
      within "#post_#{@post.id}" do
        page.should have_link 'Edit'
      end
    end
    it 'shows the edit button for another user\'s post' do
      another_post = create(:post, discussion: @discussion)
      visit discussion_posts_path(@discussion)
      within "#post_#{another_post.id}" do
        page.should have_link 'Edit'
      end
    end
    it 'allows an admin to edit their own post' do
      visit edit_discussion_post_path(@discussion, @post)
      fill_in 'post_body', with: 'Avada Kedavra!'
      click_button 'Post Reply'
      page.should have_content 'Avada Kedavra!'
    end
    it 'allows an admin to edit another posters post' do
      another_post = create(:post, discussion: @discussion)
      visit edit_discussion_post_path(@discussion, another_post)
      fill_in 'post_body', with: 'Avada Kedavra!'
      click_button 'Post Reply'
      page.should have_content 'Avada Kedavra!'
    end
    it 'allows an admin to perform a quick reply' do
      visit discussion_posts_path(@discussion)
      fill_in 'post_body', :with => 'Avada Kedavra!'
      click_button "Post Reply"
      page.should have_content 'Avada Kedavra!'
    end
    it 'allows an admin to delete their own post' do
      expect {
      visit discussion_posts_path(@discussion)
      within "#post_#{@post.id}" do
        click_link 'X'
      end
      page.should_not have_content @post.body
      }.to change(Post, :count).by(-1)
    end
    it 'allows an admin to delete another users post' do
      another_post = create(:post, discussion: @discussion, body: 'Hello World')
      expect {
      visit discussion_posts_path(@discussion)
      within "#post_#{another_post.id}" do
        click_link 'X'
      end
      page.should_not have_content another_post.body
      }.to change(Post, :count).by(-1)
    end
  end # admin
end #describe