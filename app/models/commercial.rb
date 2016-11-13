class Commercial < ApplicationRecord
  has_many :votes
  validates :title, presence: true, length: {minimum: 3, maximum: 50}
  validates :description, presence: true, length: {minimum: 3, maximum: 50}
  #validates :user_id, presence: true
  def total
    votes = self.votes
    sum = 0
    votes.each do |vote|
      sum += vote.value
    end
    sum
  end
end
