require 'rails_helper'

RSpec.describe Commercial, type: :model do

  let(:creator) {User.create(password: '12345678')}
  let!(:commercial) {Commercial.create(title: 'klondike', description: 'tasty', user: creator)}
  
  context 'search' do
    it 'returns something' do
      expect(Commercial.search('klon')).to eq([commercial])
    end

    it 'returns []' do
      expect(Commercial.search('xxxx')).to eq([])
    end
  end

  context 'total' do
    it 'has no votes' do
      expect(commercial.total).to eq(0)
    end

    let!(:user) {User.create(password: 'tasty1234')}
    let!(:vote) {Vote.create(:user_id => 1, :value => 1)}

    it 'returns []' do
      commercial.votes << vote
      expect(commercial.total).to eq(1)
    end
  end
end
