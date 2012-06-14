require 'spec_helper'

describe Discussion do
  it 'returns a title' do
    discussion = create(:discussion, title: 'Hello, my name is Elder Price')
    discussion.title.should eq 'Hello, my name is Elder Price'
  end
  it 'belongs to a user' do
    user = create(:user)
    discussion = create(:discussion, user: user)
    discussion.user.should eq user
  end
  it 'belongs to a forum' do
    forum = create(:forum)
    discussion = create(:discussion, forum: forum)
    discussion.forum.should eq forum
  end
  it 'should have many posts' do
    discussion = create(:discussion)
    posts = []
    2.times { posts << create(:post, discussion: discussion) }
    some_other_post = create(:post)
    discussion.posts.should eq posts
    discussion.posts.should_not include some_other_post
  end
  it 'returns a count of posts in the discussion' do
    discussion = create(:discussion)
    2.times { create(:post, discussion: discussion) }
    discussion.posts.size.should eq 2
  end
  it 'returns the time the last post was made' do
    Timecop.freeze(Time.now.utc)
    discussion = create(:discussion)
    post = create(:post, discussion: discussion)
    new_time = Time.now + 2.hours
    Timecop.travel(new_time)
    post = create(:post, discussion: discussion)
    discussion.updated_at.utc.to_s.should eq new_time.utc.to_s
    Timecop.return
  end
  it 'returns a list of discussions that were posted to in the last 24 hours' do
    #Freeze time at June 01, 2012 at noon
    Timecop.freeze(Time.new(2012, 06, 01, 12, 0, 0))
    old_discussion = create(:discussion)
    old_post = create(:post, discussion: old_discussion)
    #Travel to June 02, 2012 at 1pm
    Timecop.travel(Time.new(2012, 06, 02, 13, 0, 0))
    new_discussion = create(:discussion)
    new_post = create(:post, discussion: new_discussion)
    Discussion.active.should include new_discussion
    Discussion.active.should_not include old_discussion
    Timecop.return
  end
end
