class SugestionAsset < ActiveRecord::Base
   include Rails.application.routes.url_helpers  
   include Flaggable
   include Mappable

   #belongs_to :geozone
   
   #validates :title, presence: true
   #validates :latitude, length: { maximum: 22, minimum: 1 }, presence: true, \
   #         format: /\A(-|\+)?([1-8]?\d(?:\.\d{1,})?|90(?:\.0{1,6})?)\z/
   #validates :longitude, length: { maximum: 22, minimum: 1}, presence: true, \
   #         format: /\A(-|\+)?((?:1[0-7]|[1-9])?\d(?:\.\d{1,})?|180(?:\.0{1,})?)\z/
    
   belongs_to :author, -> { with_hidden }, class_name: 'User', foreign_key: 'user_id'
   validates :terms_of_service, acceptance: { allow_nil: false }, on: :create

   def url
       sugestion_asset_path(self)
   end
   
   def self.by_geozone(geozone)
      if geozone == 'all'
       where(geozone_id: nil)
      else
       where(geozone_id: geozone.presence)
      end
   end
   
   end