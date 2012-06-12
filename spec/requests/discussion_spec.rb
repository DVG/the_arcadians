require 'spec_helper'

describe 'discussions' do
  before :each do
    @user = create(:user)
    @forum = create(:forum)
    @discussion = create(:discussion, forum: @forum)
  end
  it 'renders the index action as a nested resource under forum' do
    visit forum_discussions_path(@forum)
    page.should have_selector "#discussion_#{@discussion.id}"
  end
  it 'should display the discussion title as the page heading' do
    visit forum_discussions_path(@forum)
    click_link "New Thread"
    fill_in 'discussion_title', :with => 'New Post'
    fill_in 'discussion_post_body', :with => 'Hello World'
    click_button 'Create Post'
    within "#discussion_title" do
      page.should have_content "New Post"
    end
  end
end