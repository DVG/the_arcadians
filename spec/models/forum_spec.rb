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
    thread_one = create(:thread, forum: forum)
    thread_two = create(:thread, forum: forum)
    reply = create(:reply, thread: thread_one)
    forum.threads.should eq [thread_one, thread_two]
  end
end