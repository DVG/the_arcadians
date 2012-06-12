require 'spec_helper'

describe "Forums" do
  before :each do
    @forum = create(:forum)
    @post = create(:discussion, forum: @forum)
    @reply = create(:post, discussion: @post )
    @reply_two = create(:post, discussion: @post)
  end
  it 'shows a list of forums on the forums index page' do
    visit forums_path
    page.should have_selector('tr', :id => "forum_#{@forum.id}")
  end
  it 'displays the count of posts in a particular forum' do
    visit forums_path
    within(:xpath, "//tr[@id='forum_#{@forum.id}']/td[@class='post_count']") do
      page.should have_content '2'
    end
  end
end