class Tagging < ApplicationRecord
  validates :tag_topic_id, :url_id, presence: true

  belongs_to :url,
    primary_key: :id,
    foreign_key: :url_id,
    class_name: :ShortenedUrl

  belongs_to :tag_topic,
    primary_key: :id,
    foreign_key: :tag_topic_id,
    class_name: :TagTopic
end
