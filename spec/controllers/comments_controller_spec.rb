require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe "comments#create action" do
    it "shouldn't allow unauthenticated users to post comments" do
      gram = FactoryGirl.create(:gram)
      post :create, gram_id: gram.id, comment: {comment: 'test comment'}
      expect(response).to redirect_to new_user_session_path
    end

    it "should store comment if gram is found" do
      gram = FactoryGirl.create(:gram)
      user = FactoryGirl.create(:user)
      sign_in user

      post :create, gram_id: gram.id, comment: {comment: 'test comment'}
      expect(response).to redirect_to gram_path(gram.id)
      expect(gram.comments.last.comment).to eq 'test comment'
    end

    it "should return 404 error if gram is not found" do
      gram = FactoryGirl.create(:gram)
      user = FactoryGirl.create(:user)
      sign_in user

      post :create, gram_id: 'foo', comment: {comment: 'test comment'}
      expect(response).to have_http_status(:not_found)
    end

  end

end
