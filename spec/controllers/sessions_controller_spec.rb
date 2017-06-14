require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  let!(:user) {User.create(username: 'alice', password: 'blah1234')}

  context 'create' do
    it '' do
      post :create, params: { session: {username: "alice", password: "blah1234"}}
      expect(response).to have_http_status(302)
      expect(subject.current_user).to eq(user)
    end
  end

  context 'new' do
    it '' do
      get :new
      expect(response).to have_http_status(200)
    end
  end

  context 'destroy' do
    it '' do
      delete :destroy
      expect(response).to have_http_status(302)
    end
  end
end