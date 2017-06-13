require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  let!(:user1) {User.create(username: 'john', password: 'tasty1234')}
  let!(:user2) {User.create(username: 'alice', password: 'blah1234')}

  context 'without login' do
    it 'does not show user' do
      get :show, id: 1
      expect(response).to have_http_status(302)
    end
  end

  context 'without admin' do
    it 'does not show index page' do
      subject.class.skip_before_action :authorize, raise: false
      get :index, id: 1
      expect(response).to have_http_status(302)
    end
  end

  context 'user logged in' do

    before :each do
      subject.class.skip_before_action :authorize, raise: false
      subject.class.skip_before_action :verify_is_admin, raise: false
    end

    context 'index' do
      it 'returns all users' do
        get :index
        expect(response).to have_http_status(200)
        expect(subject.instance_variable_get(:@users)).to eq([user1,user2])
      end
    end

    context 'show without correct session id' do
      it 'shows user' do
        get :show, id: 1
        expect(response).to have_http_status(302)
        expect(subject.instance_variable_get(:@user)).to eq(user1)
      end
    end

    context 'show with correct session id' do
      it 'shows user' do
        session[:user_id] = 1
        get :show, id: 1
        expect(response).to have_http_status(302)
        expect(subject.instance_variable_get(:@user)).to eq(user1)
      end
    end

    context 'edit' do
      it 'shows edit page for user' do
        get :edit, id: 1
        expect(response).to have_http_status(200)
        expect(subject.instance_variable_get(:@user)).to eq(user1)
      end
    end

    context 'create' do
      it 'produces user' do
        post :create, user: {username: 'rick and morty', password: 'funny'}
        expect(response).to have_http_status(302)
        expect(subject.instance_variable_get(:@user)).to eq(User.find_by(username: 'rick and morty'))
      end
    end

    context 'delete' do
      it 'renders user new template' do
        delete :destroy, id: 1
        expect(response).to have_http_status(302)
        expect{User.find(1)}.to raise_error
      end
    end
  end

  context 'create' do
    it 'updates a user' do
      put :update, id:1, user: {username: 'subaru', password: 'car'}
      expect(response).to have_http_status(302)
      expect(subject.instance_variable_get(:@user)).to eq(User.find_by(username: 'subaru'))
    end
  end

  context 'new' do
    it 'renders user new template' do
      get :new
      expect(response).to have_http_status(200)
      expect(subject.instance_variable_get(:@user)).to_not eq(nil)
    end
  end
end

