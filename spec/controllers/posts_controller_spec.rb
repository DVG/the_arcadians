require 'spec_helper'

describe PostsController do
  describe 'delete #destroy' do
    context 'registered user' do
      login_user
      before :each do
        @discussion = create(:discussion)
        @post = create(:post, discussion: @discussion)
      end
      it 'should not let a user delete another users post' do
        expect {delete :destroy, {:id => @post}}.to_not change(Post, :count)
      end
      it 'should let them delete their own post' do
        my_post = create(:post, discussion: @discussion, user: @user)
        expect {delete :destroy, {:id => my_post}}.to change(Post, :count).by(-1)
      end
    end
  end
end
