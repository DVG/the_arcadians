class Discussion < ActiveRecord::Base
  has_many :posts
  belongs_to :forum
  belongs_to :user
  accepts_nested_attributes_for :posts
  
  def self.active
    where('updated_at >= ?', 24.hours.ago)
  end
end
