require 'spec_helper'

describe "Breadcrumbs" do
  context 'Forum Index' do
    it 'should display the breadcrumb trail with only the root context without a link' do
      visit forums_path
      page.should have_selector "#breadcrumbs"
      within "#breadcrumbs" do
        page.should have_content "TheArcadians.net Forums"
        page.should_not have_link "TheArcadians.net Forums"
      end
    end
  end
  context 'Discussion Index' do
    before :each do
      @forum = create(:forum)
    end
    it 'should display the breadcrumb trail with the root context and the forum context' do
      visit forum_discussions_path(@forum)
      page.should have_selector "#breadcrumbs"
      within "#breadcrumbs" do
        page.should have_content "TheArcadians.net Forums"
        page.should have_content @forum.title
      end
    end
    it 'should have a link to the root context, but not the forum context' do
      visit forum_discussions_path(@forum)
      within "#breadcrumbs" do
        page.should have_link "TheArcadians.net Forums"
        page.should_not have_link @forum.title
      end
    end
  end
  context 'Post Index' do
    before :each do
      @discussion = create(:discussion)
    end
    it 'should display the breadcrumb trail with the root context, forum context and discussion context' do
      visit discussion_posts_path(@discussion)
      page.should have_selector "#breadcrumbs"
      within "#breadcrumbs" do
        page.should have_content "TheArcadians.net Forums"
        page.should have_content @discussion.forum.title
        page.should have_content @discussion.title
      end
    end
    it 'should have links for the root context and forum context, but not the discussion context' do
      visit discussion_posts_path(@discussion)
      within "#breadcrumbs" do
        page.should have_link "TheArcadians.net Forums"
        page.should have_link @discussion.forum.title
        page.should_not have_link @discussion.title
      end
    end
  end
end