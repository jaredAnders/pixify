require 'rails_helper'

RSpec.describe GramsController, type: :controller do
  describe "grams#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "grams#new action" do
    it "should require users to be signed in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the new form" do
      user = FactoryGirl.create(:user)
      sign_in user

      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "grams#create action" do
    it "should require users to be signed in" do
      post :create, gram: {caption: 'TestGram'}
      expect(response).to redirect_to new_user_session_path
    end

    it "should succesfully create a new gram" do
      user = user = FactoryGirl.create(:user)
      sign_in user

      post :create, gram: {caption: 'TestGram'}
      expect(response).to redirect_to root_path

      gram = Gram.last
      expect(gram.caption).to eq('TestGram')
      expect(gram.user).to eq(user)
    end

    it "should properly deal with validation errors" do
      user = user = FactoryGirl.create(:user)
      sign_in user

      post :create, gram: {caption: ''}
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Gram.count).to eq 0
    end
  end
end
