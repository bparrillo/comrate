require 'rails_helper'

RSpec.describe CommercialsController, type: :controller do

  let!(:commercial1) {Commercial.create(title: 'klondike', description: 'tasty')}
  let!(:commercial2) {Commercial.create(title: 'old spice', description: 'blah')}
  
  before(:each) do
    subject.class.skip_before_action :authorize, raise: false
  end

  context 'index' do
    it 'returns all commerials' do
      get :index
      expect(response).to have_http_status(200)
      expect(subject.instance_variable_get(:@commercials)).to eq([commercial1,commercial2])
    end
  end

  context 'search' do
    it 'produces commericals under search criteria' do
      get :search, search: 'klon'
      expect(response).to have_http_status(200)
      expect(subject.instance_variable_get(:@commercials)).to eq([commercial1])
    end
  end

  context 'show' do
    it 'shows commerical' do
      get :show, id: 1
      expect(response).to have_http_status(200)
      expect(subject.instance_variable_get(:@commercial)).to eq(commercial1)
    end
  end

  context 'edit' do
    it 'shows edit page for commerical' do
      get :edit, id: 1
      expect(response).to have_http_status(200)
      expect(subject.instance_variable_get(:@commercial)).to eq(commercial1)
    end
  end

  context 'create' do
    it 'produces commerical' do
      post :create, commercial: {title: 'rick and morty', description: 'funny'}
      expect(response).to have_http_status(302)
      expect(subject.instance_variable_get(:@commercial)).to eq(Commercial.find_by(title: 'rick and morty'))
    end
  end

  context 'create' do
    it 'updates a commerical' do
      put :update, id:1, commercial: {title: 'subaru', description: 'car'}
      expect(response).to have_http_status(302)
      expect(subject.instance_variable_get(:@commercial)).to eq(Commercial.find_by(title: 'subaru'))
    end
  end

  context 'new' do
    it 'renders commerical new template' do
      get :new
      expect(response).to have_http_status(200)
      expect(subject.instance_variable_get(:@commercial)).to_not eq(nil)
    end
  end

  context 'delete' do
    it 'renders commerical new template' do
      delete :destroy, id: 1
      expect(response).to have_http_status(302)
      expect{Commercial.find(1)}.to raise_error
    end
  end

  context 'like' do
    let(:user) {User.create(password: '12345678', username: 'jim')}

    it 'commerical gets positive vote' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      post :like, id: 1
      expect(response).to have_http_status(204)
      expect(Commercial.find(1).total).to eq(1)
    end
  end

  context 'dislike' do
    let(:user) {User.create(password: '12345678', username: 'jim')}

    it 'commerical gets positive vote' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      post :dislike, id: 1
      expect(response).to have_http_status(204)
      expect(Commercial.find(1).total).to eq(-1)
    end
  end
end

