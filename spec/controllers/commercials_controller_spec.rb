require 'rails_helper'

RSpec.describe CommercialsController, type: :controller do

  let(:creator) {User.create(password: '12345678', password: 'funnyabc123')}
  let!(:commercial1) {Commercial.create(title: 'klondike', description: 'tasty', user: creator)}
  let!(:commercial2) {Commercial.create(title: 'old spice', description: 'blah', user: creator)}
  
  before(:each) do
    user = creator
    allow(request.env['warden']).to receive(:authenticate!).and_return(user)
    allow(controller).to receive(:current_user).and_return(user)
  end

  context 'index' do
    it 'returns all commercials' do
      get :index
      expect(response).to have_http_status(200)
      expect(subject.instance_variable_get(:@commercials)).to eq([commercial1,commercial2])
    end
  end

  context 'search' do
    it 'produces commercials under search criteria' do
      get :search, params: {search: 'klon'}
      expect(response).to have_http_status(200)
      expect(subject.instance_variable_get(:@commercials)).to eq([commercial1])
    end
  end

  context 'show' do
    it 'shows commercial' do
      get :show, params: {id: commercial1.id}
      expect(response).to have_http_status(200)
      expect(subject.instance_variable_get(:@commercial)).to eq(commercial1)
    end
  end

  context 'edit' do
    it 'shows edit page for commercial' do
      get :edit, params: {id: commercial1.id}
      expect(response).to have_http_status(200)
      expect(subject.instance_variable_get(:@commercial)).to eq(commercial1)
    end
  end

  context 'create' do
    let(:payment_mock) { {create: true} }
    
    it 'produces commercial' do
      allow(PayPal::SDK::REST::DataTypes::Payment).to receive(:new).and_return(double(payment_mock))
      payment = 
        { type: "visa",
          number: "4567516310777851",
          expire_month: "11",
          expire_year: "2018",
          cvv2: "874",
          first_name: "Joe",
          last_name: "Shopper",
          address: "52 N Main ST",
          city: "Johnstown",
          state: "OH",
          postal_code: "43210",
          country_code: "US" }
      post :create, params: {commercial: {title: 'rick and morty', description: 'funny', com_payment: payment}}
      expect(response).to have_http_status(302)
      expect(subject.instance_variable_get(:@commercial)).to eq(Commercial.find_by(title: 'rick and morty'))
    end

    it 'fails: missing pay info' do
      post :create, params: {commercial: {title: 'rick and morty', description: 'funny', com_payment: ""}}
      expect(response).to have_http_status(302)
      expect(subject.instance_variable_get(:@commercial)).to eq(Commercial.find_by(title: 'rick and morty'))
    end

    it 'fails: missing pay info' do
      post :create, params: {commercial: {title: 'rick and morty', description: 'funny'}}
      expect(response).to have_http_status(302)
      expect(subject.instance_variable_get(:@commercial)).to eq(Commercial.find_by(title: 'rick and morty'))
    end
  end


  context 'update' do
    it 'updates a commercial' do
      put :update, params: {id: commercial1.id, commercial: {title: 'subaru', description: 'car', user: creator} }
      expect(response).to have_http_status(302)
      expect(subject.instance_variable_get(:@commercial)).to eq(Commercial.find_by(title: 'subaru'))
    end
  end

  context 'new' do
    it 'renders commercial new template' do
      get :new
      expect(response).to have_http_status(200)
      expect(subject.instance_variable_get(:@commercial)).to_not eq(nil)
    end
  end

  context 'delete' do
    it 'renders commercial new template' do
      delete :destroy, params: {id: commercial1.id}
      expect(response).to have_http_status(302)
      expect{Commercial.find(1)}.to raise_error
    end
  end

  context 'like' do
    let(:user) {User.create(password: '12345678', email: 'x@x.x')}

    it 'commercial gets positive vote' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      post :like, params: {id: commercial1.id}
      expect(response).to have_http_status(204)
      expect(Commercial.find(commercial1.id).total).to eq(1)
    end
  end

  context 'dislike' do
    let(:user) {User.create(password: '12345678', email: 'x@x.x')}
    let!(:vote) {Vote.create(:user_id => 1, :value => 1)}

    it 'commercial gets positive vote' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      post :dislike, params: {id: commercial1.id}
      expect(response).to have_http_status(204)
      expect(Commercial.find(commercial1.id).total).to eq(-1)
    end
  end
end

