class SugestionAsset < ActiveRecord::Base

include Rails.application.routes.url_helpers  
include Flaggable

belongs_to :geozone

validates :title, presence: true
validates :description, presence: true
validates :title, length: { in: 4..25 }
validates :description, length: { maximum: 25 }

validates :latitude, length: { maximum: 22, minimum: 1 }, presence: true, \
         format: /\A(-|\+)?([1-8]?\d(?:\.\d{1,})?|90(?:\.0{1,6})?)\z/
validates :longitude, length: { maximum: 22, minimum: 1}, presence: true, \
         format: /\A(-|\+)?((?:1[0-7]|[1-9])?\d(?:\.\d{1,})?|180(?:\.0{1,})?)\z/

scope :all_sugestion -> { where(visible: true) } 

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