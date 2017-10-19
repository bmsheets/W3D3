class TagTopic < ApplicationRecord
  validates :tag_topic, presence: true, uniqueness: true

  has_many :taggings,
    primary_key: :id,
    foreign_key: :tag_topic_id,
    class_name: :Tagging

  has_many :urls,
    through: :taggings,
    source: :url

  def popular_links
    urls.joins(:visits)
      .group(:short_url)
      .order("COUNT(visits.id) DESC")
      .select('long_url, short_url, COUNT(visits.id) as number_of_visits')
      .limit(5)
  end
end
