require 'spec_helper'

describe "Posts" do
  before :each do
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
      fill_in 'post_body', :with => 'Hello World'
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
      fill_in 'post_body', :with => 'Hello World'
      click_button 'Create Post'
      current_path.should eq discussion_posts_path(Discussion.last)
    end
    it 'should display the post on the discussion posts index after posting' do
      visit forum_discussions_path(@forum)
      click_link "New Thread"
      fill_in 'discussion_title', :with => 'New Post'
      fill_in 'post_body', :with => 'Hello World'
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
  
  context 'Quote', js: true do
    it "has a quote button" do
      visit discussion_posts_path(@discussion)
      within "#post_#{@post.id}" do
         page.should have_link 'Quote'
      end
    end
    it 'puts the post content in the quick-reply form' do
      visit discussion_posts_path(@discussion)
      within "#post_#{@post.id}" do
         click_link 'Quote'
      end
      find("#post_body")[:value].should include @post.body
    end
    it 'wraps the post content in [quote] tags' do
      visit discussion_posts_path(@discussion)
      within "#post_#{@post.id}" do
         click_link 'Quote'
      end
      find("#post_body")[:value].should include "[quote]#{@post.body}[/quote]"
    end
    it 'inserts two carriage returns after the post content.' do
      visit discussion_posts_path(@discussion)
      within "#post_#{@post.id}" do
         click_link 'Quote'
      end
      find("#post_body")[:value].should include "\n\n"
    end
    it 'gives focus to the post_body textarea'
  end
  
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
      sleep 1
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
    end # discussion should remain intact
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
  context 'Toolbar', js: true do
    context 'quick reply' do
      describe 'bold' do
        it 'shows a bold button' do
          visit discussion_posts_path(@discussion)
          within '#quick_reply' do
            within "#toolbar" do
              page.should have_link 'b'
            end
          end
        end #it
        it 'inserts [b] tags into the text area' do
          visit discussion_posts_path(@discussion)
          click_link 'b'
          find("#post_body")[:value].should match /[b]*.[\/b]/
        end
        it 'wraps the selected text in [b] tags' do
          visit discussion_posts_path(@discussion)
          fill_in "post_body", with: 'Hello World'
          page.execute_script %Q{ $('#post_body').select() } 
          click_link 'b'
          find("#post_body")[:value].should eq "[b]Hello World[/b]"
        end
      end #bold
      describe 'italics' do
        it 'shows an italics button' do
          visit discussion_posts_path(@discussion)
          within '#quick_reply' do
            within "#toolbar" do
              page.should have_link 'i'
            end
          end
        end
        it 'inserts [i] tags into the text area' do
          visit discussion_posts_path(@discussion)
          click_link 'i'
          find("#post_body")[:value].should match /[i]*.[\/i]/
        end
        it 'wraps the selected text in [i] tags' do
          visit discussion_posts_path(@discussion)
          fill_in "post_body", with: 'Hello World'
          page.execute_script %Q{ $('#post_body').select() } 
          click_link 'i'
          find("#post_body")[:value].should eq "[i]Hello World[/i]"
        end
      end #italics
      
      describe 'underline' do
        it 'shows an underline button' do
          visit discussion_posts_path(@discussion)
          within '#quick_reply' do
            within "#toolbar" do
              page.should have_link 'u'
            end
          end
        end
        it 'inserts [u] tags into the text area' do
          visit discussion_posts_path(@discussion)
          click_link 'u'
          find("#post_body")[:value].should match /[u]*.[\/u]/
        end
        it 'wraps the selected text in [u] tags' do
          visit discussion_posts_path(@discussion)
          fill_in "post_body", with: 'Hello World'
          page.execute_script %Q{ $('#post_body').select() } 
          click_link 'u'
          find("#post_body")[:value].should eq "[u]Hello World[/u]"
        end
      end #underline
      
      describe 'Quote' do
        it 'shows a quote button' do
          visit discussion_posts_path(@discussion)
          within "#toolbar" do
            page.should have_link 'quote'
          end
        end
        it 'inserts [quote] tags into the text area' do
          visit discussion_posts_path(@discussion)
          within "#toolbar" do
            click_link 'quote'
          end
          find("#post_body")[:value].should match /[quote]*.[\/quote]/
        end
        it 'wraps the selected text in [quote] tags' do
          visit discussion_posts_path(@discussion)
          fill_in "post_body", with: 'Hello World'
          page.execute_script %Q{ $('#post_body').select() } 
          within "#toolbar" do
            click_link 'quote'
          end
          find("#post_body")[:value].should eq "[quote]Hello World[/quote]"
        end
      end # quote
      
      describe 'code' do
        it 'shows a quote button' do
          visit discussion_posts_path(@discussion)
          within "#toolbar" do
            page.should have_link 'code'
          end
        end
        it 'inserts [code] tags into the text area' do
          visit discussion_posts_path(@discussion)
          within "#toolbar" do
            click_link 'code'
          end
          find("#post_body")[:value].should match /[code]*.[\/code]/
        end
        it 'wraps the selected text in [code] tags' do
          visit discussion_posts_path(@discussion)
          fill_in "post_body", with: 'Hello World'
          page.execute_script %Q{ $('#post_body').select() } 
          within "#toolbar" do
            click_link 'code'
          end
          find("#post_body")[:value].should eq "[code]Hello World[/code]"
        end
      end # code
      
      describe 'list' do
       it 'shows a list button' do
          visit discussion_posts_path(@discussion)
          within "#toolbar" do
            page.should have_link 'list'
          end
        end
        it 'inserts [list] tags into the text area' do
          visit discussion_posts_path(@discussion)
          within "#toolbar" do
            click_link 'list'
          end
          find("#post_body")[:value].should match /[list]*.[\/list]/
        end
        it 'wraps the selected text in [list] tags' do
          visit discussion_posts_path(@discussion)
          fill_in "post_body", with: 'Hello World'
          page.execute_script %Q{ $('#post_body').select() } 
          within "#toolbar" do
            click_link 'list'
          end
          find("#post_body")[:value].should eq "[list]Hello World[/list]"
        end
      end #list
      describe 'list item' do
        it 'shows a list item button' do
          visit discussion_posts_path(@discussion)
          within "#toolbar" do
            page.should have_link '[*]'
          end
        end
        it 'inserts a [*]' do
          visit discussion_posts_path(@discussion)
          within "#toolbar" do
            click_link '[*]'
          end
          find("#post_body")[:value].should match /[\*]/
        end
        it 'puts a [*] before the selected text' do
          visit discussion_posts_path(@discussion)
          fill_in "post_body", with: 'Hello World'
          page.execute_script %Q{ $('#post_body').select() } 
          within "#toolbar" do
            click_link '[*]'
          end
          find("#post_body")[:value].should eq "[*] Hello World"
        end
      end #list item
      describe 'img' do
      it 'shows a img button' do
         visit discussion_posts_path(@discussion)
         within "#toolbar" do
           page.should have_link 'img'
         end
       end
       it 'inserts [img] tags into the text area' do
         visit discussion_posts_path(@discussion)
         within "#toolbar" do
           click_link 'img'
         end
         find("#post_body")[:value].should match /[img]*.[\/img]/
       end
       it 'wraps the selected text in [img] tags' do
         visit discussion_posts_path(@discussion)
         fill_in "post_body", with: 'Hello World'
         page.execute_script %Q{ $('#post_body').select() } 
         within "#toolbar" do
           click_link 'img'
         end
         find("#post_body")[:value].should eq "[img]Hello World[/img]"
       end
      end # img
      describe 'url' do
        it 'shows a url button' do
           visit discussion_posts_path(@discussion)
           within "#toolbar" do
             page.should have_link 'url'
           end
         end
         it 'wraps the provided url in [url] tags' do
           visit discussion_posts_path(@discussion)
            within "#toolbar" do
              click_link 'url'
            end
            prompt = page.driver.browser.switch_to.alert
            prompt.send_keys('http://www.google.com')
            prompt.accept
            find("#post_body")[:value].should eq "[url]http://www.google.com[/url]"
         end
      end #url
      describe 'bigimg' do
        it 'shows a img button' do
           visit discussion_posts_path(@discussion)
           within "#toolbar" do
             page.should have_link 'bigimg'
           end
         end
         it 'inserts [bigimg] tags into the text area' do
           visit discussion_posts_path(@discussion)
           within "#toolbar" do
             click_link 'bigimg'
           end
           find("#post_body")[:value].should match /[bigimg]*.[\/bigimg]/
         end
         it 'wraps the selected text in [bigimg] tags' do
           visit discussion_posts_path(@discussion)
           fill_in "post_body", with: 'Hello World'
           page.execute_script %Q{ $('#post_body').select() } 
           within "#toolbar" do
             click_link 'bigimg'
           end
           find("#post_body")[:value].should eq "[bigimg]Hello World[/bigimg]"
         end
      end # big img
      describe 'spoiler' do
        it 'shows a spoiler button' do
           visit discussion_posts_path(@discussion)
           within "#toolbar" do
             page.should have_link 'spoiler'
           end
         end
         it 'inserts [spoiler] tags into the text area' do
           visit discussion_posts_path(@discussion)
           within "#toolbar" do
             click_link 'spoiler'
           end
           find("#post_body")[:value].should match /[spoiler]*.[\/spoiler]/
         end
         it 'wraps the selected text in [spoiler] tags' do
           visit discussion_posts_path(@discussion)
           fill_in "post_body", with: 'Hello World'
           page.execute_script %Q{ $('#post_body').select() } 
           within "#toolbar" do
             click_link 'spoiler'
           end
           find("#post_body")[:value].should eq "[spoiler]Hello World[/spoiler]"
         end
      end
      
    end #quick reply
    
    context 'New Thread' do
      describe 'bold' do
        it 'shows a bold button' do
          visit new_forum_discussion_path(@forum)
          within "#toolbar" do
            page.should have_link 'b'
          end
        end
        it 'inserts [b] tags into the text area' do
          visit new_forum_discussion_path(@forum)
          click_link 'b'
          find("#post_body")[:value].should match /[b]*.[\/b]/
        end
        it 'wraps the selected text in [b] tags' do
          visit new_forum_discussion_path(@forum)
          fill_in "post_body", with: 'Hello World'
          page.execute_script %Q{ $('#post_body').select() } 
          click_link 'b'
          find("#post_body")[:value].should eq "[b]Hello World[/b]"
        end
      end # bold
      
      describe 'italics' do
        it 'shows an italics button' do
          visit new_forum_discussion_path(@forum)
          within "#toolbar" do
            page.should have_link 'i'
          end
        end
        it 'inserts [i] tags into the text area' do
          visit new_forum_discussion_path(@forum)
          click_link 'i'
          find("#post_body")[:value].should match /[i]*.[\/i]/
        end
        it 'wraps the selected text in [i] tags' do
          visit new_forum_discussion_path(@forum)
          fill_in "post_body", with: 'Hello World'
          page.execute_script %Q{ $('#post_body').select() } 
          click_link 'i'
          find("#post_body")[:value].should eq "[i]Hello World[/i]"
        end
      end #italics
      
      describe 'underline' do
        it 'shows an underline button' do
          visit new_forum_discussion_path(@forum)
          within "#toolbar" do
            page.should have_link 'u'
          end
        end
        it 'inserts [u] tags into the text area' do
          visit new_forum_discussion_path(@forum)
          click_link 'u'
          find("#post_body")[:value].should match /[u]*.[\/u]/
        end
        it 'wraps the selected text in [u] tags' do
          visit new_forum_discussion_path(@forum)
          fill_in "post_body", with: 'Hello World'
          page.execute_script %Q{ $('#post_body').select() } 
          click_link 'u'
          find("#post_body")[:value].should eq "[u]Hello World[/u]"
        end
      end #underline
      
      describe 'Quote' do
        it 'shows a quote button' do
          visit new_forum_discussion_path(@forum)
          within "#toolbar" do
            page.should have_link 'quote'
          end
        end
        it 'inserts [quote] tags into the text area' do
          visit new_forum_discussion_path(@forum)
          within "#toolbar" do
            click_link 'quote'
          end
          find("#post_body")[:value].should match /[quote]*.[\/quote]/
        end
        it 'wraps the selected text in [quote] tags' do
          visit new_forum_discussion_path(@forum)
          fill_in "post_body", with: 'Hello World'
          page.execute_script %Q{ $('#post_body').select() } 
          within "#toolbar" do
            click_link 'quote'
          end
          find("#post_body")[:value].should eq "[quote]Hello World[/quote]"
        end
      end # quote
      
      describe 'code' do
        it 'shows a quote button' do
          visit new_forum_discussion_path(@forum)
          within "#toolbar" do
            page.should have_link 'code'
          end
        end
        it 'inserts [code] tags into the text area' do
          visit new_forum_discussion_path(@forum)
          within "#toolbar" do
            click_link 'code'
          end
          find("#post_body")[:value].should match /[code]*.[\/code]/
        end
        it 'wraps the selected text in [code] tags' do
          visit new_forum_discussion_path(@forum)
          fill_in "post_body", with: 'Hello World'
          page.execute_script %Q{ $('#post_body').select() } 
          within "#toolbar" do
            click_link 'code'
          end
          find("#post_body")[:value].should eq "[code]Hello World[/code]"
        end
      end # code
      
      describe 'list' do
       it 'shows a list button' do
          visit new_forum_discussion_path(@forum)
          within "#toolbar" do
            page.should have_link 'list'
          end
        end
        it 'inserts [list] tags into the text area' do
          visit new_forum_discussion_path(@forum)
          within "#toolbar" do
            click_link 'list'
          end
          find("#post_body")[:value].should match /[list]*.[\/list]/
        end
        it 'wraps the selected text in [list] tags' do
          visit new_forum_discussion_path(@forum)
          fill_in "post_body", with: 'Hello World'
          page.execute_script %Q{ $('#post_body').select() } 
          within "#toolbar" do
            click_link 'list'
          end
          find("#post_body")[:value].should eq "[list]Hello World[/list]"
        end
      end #list
      describe 'list item' do
        it 'shows a list item button' do
          visit new_forum_discussion_path(@forum)
          within "#toolbar" do
            page.should have_link '[*]'
          end
        end
        it 'inserts a [*]' do
          visit new_forum_discussion_path(@forum)
          within "#toolbar" do
            click_link '[*]'
          end
          find("#post_body")[:value].should match /[\*]/
        end
        it 'puts a [*] before the selected text' do
          visit new_forum_discussion_path(@forum)
          fill_in "post_body", with: 'Hello World'
          page.execute_script %Q{ $('#post_body').select() } 
          within "#toolbar" do
            click_link '[*]'
          end
          find("#post_body")[:value].should eq "[*] Hello World"
        end
      end #list item
      describe 'img' do
      it 'shows a img button' do
         visit new_forum_discussion_path(@forum)
         within "#toolbar" do
           page.should have_link 'img'
         end
       end
       it 'inserts [img] tags into the text area' do
         visit new_forum_discussion_path(@forum)
         within "#toolbar" do
           click_link 'img'
         end
         find("#post_body")[:value].should match /[img]*.[\/img]/
       end
       it 'wraps the selected text in [img] tags' do
         visit new_forum_discussion_path(@forum)
         fill_in "post_body", with: 'Hello World'
         page.execute_script %Q{ $('#post_body').select() } 
         within "#toolbar" do
           click_link 'img'
         end
         find("#post_body")[:value].should eq "[img]Hello World[/img]"
       end
      end # img
      describe 'url' do
        it 'shows a url button' do
           visit new_forum_discussion_path(@forum)
           within "#toolbar" do
             page.should have_link 'url'
           end
         end
         it 'wraps the provided url in [url] tags' do
           visit new_forum_discussion_path(@forum)
            within "#toolbar" do
              click_link 'url'
            end
            prompt = page.driver.browser.switch_to.alert
            prompt.send_keys('http://www.google.com')
            prompt.accept
            find("#post_body")[:value].should eq "[url]http://www.google.com[/url]"
         end
      end #url
      describe 'bigimg' do
        it 'shows a img button' do
           visit new_forum_discussion_path(@forum)
           within "#toolbar" do
             page.should have_link 'bigimg'
           end
         end
         it 'inserts [bigimg] tags into the text area' do
           visit new_forum_discussion_path(@forum)
           within "#toolbar" do
             click_link 'bigimg'
           end
           find("#post_body")[:value].should match /[bigimg]*.[\/bigimg]/
         end
         it 'wraps the selected text in [bigimg] tags' do
           visit new_forum_discussion_path(@forum)
           fill_in "post_body", with: 'Hello World'
           page.execute_script %Q{ $('#post_body').select() } 
           within "#toolbar" do
             click_link 'bigimg'
           end
           find("#post_body")[:value].should eq "[bigimg]Hello World[/bigimg]"
         end
      end # big img
      describe 'spoiler' do
        it 'shows a spoiler button' do
           visit new_forum_discussion_path(@forum)
           within "#toolbar" do
             page.should have_link 'spoiler'
           end
         end
         it 'inserts [spoiler] tags into the text area' do
           visit new_forum_discussion_path(@forum)
           within "#toolbar" do
             click_link 'spoiler'
           end
           find("#post_body")[:value].should match /[spoiler]*.[\/spoiler]/
         end
         it 'wraps the selected text in [spoiler] tags' do
           visit new_forum_discussion_path(@forum)
           fill_in "post_body", with: 'Hello World'
           page.execute_script %Q{ $('#post_body').select() } 
           within "#toolbar" do
             click_link 'spoiler'
           end
           find("#post_body")[:value].should eq "[spoiler]Hello World[/spoiler]"
         end
      end #spoiler
      
    end # new thread
    
    context 'Normal Reply' do
      describe 'bold' do
        it 'shows a bold button' do
          visit new_discussion_post_path(@discussion)
          within "#toolbar" do
            page.should have_link 'b'
          end
        end
        it 'inserts [b] tags into the text area' do
          visit new_discussion_post_path(@discussion)
          click_link 'b'
          find("#post_body")[:value].should match /[b]*.[\/b]/
        end
        it 'wraps the selected text in [b] tags' do
          visit new_discussion_post_path(@discussion)
          fill_in "post_body", with: 'Hello World'
          page.execute_script %Q{ $('#post_body').select() } 
          click_link 'b'
          find("#post_body")[:value].should eq "[b]Hello World[/b]"
        end
      end # bold
      
      describe 'italics' do
        it 'shows an italics button' do
          visit new_discussion_post_path(@discussion)
          within "#toolbar" do
            page.should have_link 'i'
          end
        end
        it 'inserts [i] tags into the text area' do
          visit new_discussion_post_path(@discussion)
          click_link 'i'
          find("#post_body")[:value].should match /[i]*.[\/i]/
        end
        it 'wraps the selected text in [i] tags' do
          visit new_discussion_post_path(@discussion)
          fill_in "post_body", with: 'Hello World'
          page.execute_script %Q{ $('#post_body').select() } 
          click_link 'i'
          find("#post_body")[:value].should eq "[i]Hello World[/i]"
        end
      end #italics
    
      describe 'underline' do
        it 'shows an underline button' do
          visit new_discussion_post_path(@discussion)
          within "#toolbar" do
            page.should have_link 'u'
          end
        end
        it 'inserts [u] tags into the text area' do
          visit new_discussion_post_path(@discussion)
          click_link 'u'
          find("#post_body")[:value].should match /[u]*.[\/u]/
        end
        it 'wraps the selected text in [u] tags' do
          visit new_discussion_post_path(@discussion)
          fill_in "post_body", with: 'Hello World'
          page.execute_script %Q{ $('#post_body').select() } 
          click_link 'u'
          find("#post_body")[:value].should eq "[u]Hello World[/u]"
        end
      end #underline
      
      describe 'Quote' do
        it 'shows a quote button' do
          visit new_discussion_post_path(@discussion)
          within "#toolbar" do
            page.should have_link 'quote'
          end
        end
        it 'inserts [quote] tags into the text area' do
          visit new_discussion_post_path(@discussion)
          within "#toolbar" do
            click_link 'quote'
          end
          find("#post_body")[:value].should match /[quote]*.[\/quote]/
        end
        it 'wraps the selected text in [quote] tags' do
         visit new_discussion_post_path(@discussion)
          fill_in "post_body", with: 'Hello World'
          page.execute_script %Q{ $('#post_body').select() } 
          within "#toolbar" do
            click_link 'quote'
          end
          find("#post_body")[:value].should eq "[quote]Hello World[/quote]"
        end
      end # quote
      
      describe 'code' do
        it 'shows a quote button' do
          visit new_discussion_post_path(@discussion)
          within "#toolbar" do
            page.should have_link 'code'
          end
        end
        it 'inserts [code] tags into the text area' do
          visit new_discussion_post_path(@discussion)
          within "#toolbar" do
            click_link 'code'
          end
          find("#post_body")[:value].should match /[code]*.[\/code]/
        end
        it 'wraps the selected text in [code] tags' do
          visit new_discussion_post_path(@discussion)
          fill_in "post_body", with: 'Hello World'
          page.execute_script %Q{ $('#post_body').select() } 
          within "#toolbar" do
            click_link 'code'
          end
          find("#post_body")[:value].should eq "[code]Hello World[/code]"
        end
      end # code
    
      describe 'list' do
       it 'shows a list button' do
          visit new_discussion_post_path(@discussion)
          within "#toolbar" do
            page.should have_link 'list'
          end
        end
        it 'inserts [list] tags into the text area' do
          visit new_discussion_post_path(@discussion)
          within "#toolbar" do
            click_link 'list'
          end
          find("#post_body")[:value].should match /[list]*.[\/list]/
        end
        it 'wraps the selected text in [list] tags' do
          visit new_discussion_post_path(@discussion)
          fill_in "post_body", with: 'Hello World'
          page.execute_script %Q{ $('#post_body').select() } 
          within "#toolbar" do
            click_link 'list'
          end
          find("#post_body")[:value].should eq "[list]Hello World[/list]"
        end
      end #list
      describe 'list item' do
        it 'shows a list item button' do
          visit new_discussion_post_path(@discussion)
          within "#toolbar" do
            page.should have_link '[*]'
          end
        end
        it 'inserts a [*]' do
          visit new_discussion_post_path(@discussion)
          within "#toolbar" do
            click_link '[*]'
          end
          find("#post_body")[:value].should match /[\*]/
        end
        it 'puts a [*] before the selected text' do
          visit new_discussion_post_path(@discussion)
          fill_in "post_body", with: 'Hello World'
          page.execute_script %Q{ $('#post_body').select() } 
          within "#toolbar" do
            click_link '[*]'
          end
          find("#post_body")[:value].should eq "[*] Hello World"
        end
      end #list item
      describe 'img' do
      it 'shows a img button' do
         visit new_discussion_post_path(@discussion)
         within "#toolbar" do
           page.should have_link 'img'
         end
       end
       it 'inserts [img] tags into the text area' do
         visit new_discussion_post_path(@discussion)
         within "#toolbar" do
           click_link 'img'
         end
         find("#post_body")[:value].should match /[img]*.[\/img]/
       end
       it 'wraps the selected text in [img] tags' do
         visit new_discussion_post_path(@discussion)
         fill_in "post_body", with: 'Hello World'
         page.execute_script %Q{ $('#post_body').select() } 
         within "#toolbar" do
           click_link 'img'
         end
         find("#post_body")[:value].should eq "[img]Hello World[/img]"
       end
      end # img
      describe 'url' do
        it 'shows a url button' do
           visit new_discussion_post_path(@discussion)
           within "#toolbar" do
             page.should have_link 'url'
           end
         end
         it 'wraps the provided url in [url] tags' do
           visit new_discussion_post_path(@discussion)
            within "#toolbar" do
              click_link 'url'
            end
            prompt = page.driver.browser.switch_to.alert
            prompt.send_keys('http://www.google.com')
            prompt.accept
            find("#post_body")[:value].should eq "[url]http://www.google.com[/url]"
         end
      end #url
      describe 'bigimg' do
        it 'shows a img button' do
           visit new_discussion_post_path(@discussion)
           within "#toolbar" do
             page.should have_link 'bigimg'
           end
         end
         it 'inserts [bigimg] tags into the text area' do
           visit new_discussion_post_path(@discussion)
           within "#toolbar" do
             click_link 'bigimg'
           end
           find("#post_body")[:value].should match /[bigimg]*.[\/bigimg]/
         end
         it 'wraps the selected text in [bigimg] tags' do
           visit new_discussion_post_path(@discussion)
           fill_in "post_body", with: 'Hello World'
           page.execute_script %Q{ $('#post_body').select() } 
           within "#toolbar" do
             click_link 'bigimg'
           end
           find("#post_body")[:value].should eq "[bigimg]Hello World[/bigimg]"
         end
      end # big img
      describe 'spoiler' do
        it 'shows a spoiler button' do
           visit new_discussion_post_path(@discussion)
           within "#toolbar" do
             page.should have_link 'spoiler'
           end
         end
         it 'inserts [spoiler] tags into the text area' do
           visit new_discussion_post_path(@discussion)
           within "#toolbar" do
             click_link 'spoiler'
           end
           find("#post_body")[:value].should match /[spoiler]*.[\/spoiler]/
         end
         it 'wraps the selected text in [spoiler] tags' do
           visit new_discussion_post_path(@discussion)
           fill_in "post_body", with: 'Hello World'
           page.execute_script %Q{ $('#post_body').select() } 
           within "#toolbar" do
             click_link 'spoiler'
           end
           find("#post_body")[:value].should eq "[spoiler]Hello World[/spoiler]"
         end
      end #spoiler
    end # reply
  end #toolbar
end