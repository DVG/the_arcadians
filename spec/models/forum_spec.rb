require 'spec_helper'

describe Forum do
  it 'returns the title of the forum' do
    forum = create(:forum, title: 'On Topic')
    forum.title.should eq 'On Topic'
  end
  it 'is invalid without a title' do
    forum = build(:forum, title: nil)
    forum.should_not be_valid
  end
  it 'is invalid without a unique title' do
    forum = create(:forum)
    forum_two = build(:forum, title: forum.title)
    forum_two.should_not be_valid
  end
  it 'is valid without a description' do
    forum = create(:forum, description: nil)
    forum.should be_valid
  end
  it 'returns all first posts that belong to the forum' do
    forum = create(:forum)
    thread_one = create(:discussion, forum: forum)
    thread_two = create(:discussion, forum: forum)
    reply = create(:post, discussion: thread_one)
    forum.discussions.should eq [thread_one, thread_two]
  end
  it 'returns all posts by way of discussions' do
    forum = create(:forum)
    discussion = create(:discussion, forum: forum)
    post_one = create(:post, discussion: discussion)
    post_two = create(:post, discussion: discussion)
    some_other_discussion = create(:discussion)
    other_post = create(:post, discussion: some_other_discussion)
    forum.posts.should eq [post_one, post_two]
    forum.posts.should_not include other_post
  end
  it 'returns the size of posts from the counter cache' do
    forum = create(:forum)
    discussion = create(:discussion, forum: forum)
    post_one = create(:post, discussion: discussion)
    post_two = create(:post, discussion: discussion)
    forum.posts.size.should eq 2
  end
  it 'decrements the counter cache' do
    forum = create(:forum)
    discussion = create(:discussion, forum: forum)
    post_one = create(:post, discussion: discussion)
    post_two = create(:post, discussion: discussion)
    forum.posts.size.should eq 2
    post_two.destroy
    forum.posts.size.should eq 1
  end
end