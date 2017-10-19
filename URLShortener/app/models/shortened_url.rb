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

  has_many :taggings,
    primary_key: :id,
    foreign_key: :url_id,
    class_name: :Tagging

  has_many :tag_topics,
    through: :taggings,
    source: :tag_topic

  def self.random_code
    code = nil
    loop do
      code = SecureRandom.urlsafe_base64
      break unless ShortenedUrl.exists?(short_url: code)
    end
    code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    ShortenedUrl.create(long_url: long_url, short_url: random_code, user_id: user.id)
  end

  def self.prune(n)
    all
    .where('updated_at < ?', n.minutes.ago)
    .destroy_all
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
