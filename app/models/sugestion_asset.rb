class SugestionAsset < ActiveRecord::Base
   include Rails.application.routes.url_helpers  
   include Flaggable
   include Mappable

   belongs_to :geozone
   
  
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