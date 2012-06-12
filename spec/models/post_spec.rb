require 'spec_helper'

describe Post do
  it 'should return the title of the post' do
    post = FactoryGirl.create(:post, title: 'Hello World')
    post.title.should eq 'Hello World'
  end
  it 'should return the body of the post' do
    post = FactoryGirl.create(:post, body: 'Didactically speaking, seminal evidence seams to explicate that your repudation for entropy supprts my theory of space-time synthesis. Of this I am irrefutably confident.')
    post.body.should eq "Didactically speaking, seminal evidence seams to explicate that your repudation for entropy supprts my theory of space-time synthesis. Of this I am irrefutably confident."
  end
  it 'should return a parent_post_id if a subsequent post in a thread' do
    thread = FactoryGirl.create(:discussion)
    reply = FactoryGirl.create(:post, discussion: thread)
    reply.discussion.should eq thread
  end
  it 'should belong to a user' do
    user = FactoryGirl.create(:user)
    post = FactoryGirl.create(:post, user: user)
    post.user.should eq user
  end
  it 'should have a forum by way of discussion' do
    forum = create(:forum)
    discussion = create(:discussion, forum: forum)
    post = create(:post, discussion: discussion)
    post.forum.should eq forum
  end
end