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
    thread = FactoryGirl.create(:thread)
    reply = FactoryGirl.create(:reply, thread: thread)
    reply.thread.should eq thread
  end
  it 'should return nil for parent_post_id if the first post in the thread' do
    thread = create(:thread)
    thread.thread.should be_nil
  end
  it 'should belong to a user' do
    user = FactoryGirl.create(:user)
    post = FactoryGirl.create(:post, user: user)
    post.user.should eq user
  end
  it 'should belong to a forum' do
    forum = create(:forum)
    thread = create(:thread, forum: forum)
    thread.forum.should eq forum
  end
end