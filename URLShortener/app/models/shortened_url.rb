class ShortenedUrl < ApplicationRecord
  validates :long_url, :short_url, :user_id, presence: true
  validates :short_url, uniqueness: true

  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  has_many :visits,
    primary_key: :id,
    foreign_key: :url_id,
    class_name: :Visit

  has_many :visitors,
    Proc.new { distinct },
    through: :visits,
    source: :visitor

  def self.random_code
    code = nil
    loop do
      code = SecureRandom.urlsafe_base64
      break unless ShortenedUrl.exists?(short_url: code)
    end
    code
  end

  def self.make_shortened_url(user, long_url)
    ShortenedUrl.new(long_url: long_url, short_url: random_code, user_id: user.id)
  end

  def num_clicks
    visits.count
  end

  def num_uniques
    visitors.count
  end

  def num_recent_uniques
    visits
      .select(:visitor_id)
      .distinct
      .where('created_at > ?', 10.minutes.ago)
      .count
  end
end
