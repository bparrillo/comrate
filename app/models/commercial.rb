class Commercial < ApplicationRecord
  has_many :votes
  validates :title, presence: true, length: {minimum: 3, maximum: 50}
  validates :description, presence: true, length: {minimum: 3, maximum: 50}
  #validates :user_id, presence: true
  has_attached_file :video, processors: [:transcoder] #, default_url: "/images/:style/missing.png"
  do_not_validate_attachment_file_type :video # content_type: /.+/
  def total
    votes = self.votes
    sum = 0
    votes.each do |vote|
      sum += vote.value
    end
    sum
  end
end
