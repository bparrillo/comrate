require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do

  let!(:user) {User.create(username: 'alice', password: 'blah1234')}

  context 'current_user' do
    it 'has session' do
      session[:user_id] = 1
      expect(subject.current_user).to eq(user)
    end

    it 'has no session' do
      expect(subject.current_user).to eq(nil)
    end
  end

  context 'logged_in?' do
    it 'has session' do
      session[:user_id] = 1
      expect(subject.logged_in?).to eq(true)
    end

    it 'has no session' do
      expect(subject.logged_in?).to eq(false)
    end
  end
end