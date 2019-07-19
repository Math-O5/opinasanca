class SugestionAsset < ActiveRecord::Base
    include Rails.application.routes.url_helpers  
    include Flaggable
    include Mappable
    include Filterable
    include Imageable
    include Taggable

    
    #belongs_to :geozone
    belongs_to :author, -> { with_hidden }, class_name: 'User', foreign_key: 'author_id'
    has_many :comments, as: :commentable, dependent: :destroy

    validates :title, presence: true
    validates :terms_of_service, acceptance: { allow_nil: false }, on: :create
    #validates :latitude, length: { maximum: 22, minimum: 1 }, presence: true, \
    #         format: /\A(-|\+)?([1-8]?\d(?:\.\d{1,})?|90(?:\.0{1,6})?)\z/
    #validates :longitude, length: { maximum: 22, minimum: 1}, presence: true, \
    #         format: /\A(-|\+)?((?:1[0-7]|[1-9])?\d(?:\.\d{1,})?|180(?:\.0{1,})?)\z/

    scope :sort_by_hot_score,        -> { reorder(hot_score: :desc) }
    scope :sort_by_confidence_score, -> { reorder(confidence_score: :desc) }
    scope :sort_by_created_at,       -> { reorder(created_at: :desc) }
    scope :sort_by_most_commented,   -> { reorder(comments_count: :desc) }
    scope :sort_by_random,           -> { reorder("RANDOM()") }
    scope :sort_by_relevance,        -> { all }
    scope :sort_by_flags,            -> { order(flags_count: :desc, updated_at: :desc) }
    scope :sort_by_recommendations,  -> { order(cached_votes_total: :desc) }
    scope :public_for_api,           -> { all }


    def url
        sugestion_asset_path(self)
    end

    def editable?
    end

    def editable_by?(user)
        author_id == user.id 
    end

    end