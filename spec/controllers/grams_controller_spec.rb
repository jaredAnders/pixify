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
      user = FactoryGirl.create(:user)
      sign_in user

      post :create, gram: {caption: 'TestGram'}
      expect(response).to redirect_to root_path

      gram = Gram.last
      expect(gram.caption).to eq('TestGram')
      expect(gram.user).to eq(user)
    end

    it "should properly deal with validation errors" do
      user = FactoryGirl.create(:user)
      sign_in user

      post :create, gram: {caption: ''}
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Gram.count).to eq 0
    end
  end

  describe "grams#show action" do
    it "should display detail page if gram is found" do
      gram = FactoryGirl.create(:gram)
      get :show, id: gram.id
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if gram is not found" do
      get :show, id: "foo"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "grams#edit action" do
    it "should display edit page if gram is found" do
      gram = FactoryGirl.create(:gram)
      get :edit, id: gram.id
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if gram is not found" do
      get :edit, id: "foo"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "grams#update action" do
    it "should succesfully update gram in db" do
      gram = FactoryGirl.create(:gram, caption: 'initial value')
      patch :update, id: gram.id, gram: { caption: 'updated' }
      expect(response).to redirect_to root_path
      gram.reload
      expect(gram.caption).to eq 'updated'
    end

    it "should return a 404 error if gram is not found" do
      patch :update, id: "foo", gram: { caption: 'updated'}
      expect(response).to have_http_status(:not_found)
    end

    it "should render the edit form if input data is not valid" do
      gram = FactoryGirl.create(:gram, caption: 'initial value')
      patch :update, id: gram.id, gram: { caption: '' }
      expect(response).to have_http_status(:unprocessable_entity)
      gram.reload
      expect(gram.caption).to eq 'initial value'
    end
  end

  describe "grams#destroy action" do
    it "should successfully delete gram in db" do
      gram = FactoryGirl.create(:gram)
      delete :destroy, id: gram.id
      expect(response).to redirect_to root_path
      gram = Gram.find_by_id(gram.id)
      expect(gram).to eq nil
    end

    it "should return a 404 error if gram is not found" do
      delete :destroy, id: 'foo'
      expect(response).to have_http_status(:not_found)
    end
  end

end
