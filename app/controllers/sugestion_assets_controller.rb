class SugestionAssetsController < ApplicationController
  include FeatureFlags
  include FlagActions
  
  skip_authorization_check

  before_action :authenticate_user!, except: [:index, :show, :json_data]

  feature_flag :sugestion_assets
  respond_to :html, :js

  def show  
    load_map 
  end

  def new 
    @sugestion_asset = SugestionAsset.new()
    @map_location =  SugestionAsset.new()
    load_map


  end

  def create
    @sugestion_asset = SugestionAsset.new(sugestions_assets_params)
    @map_location = MapLocation.new()

    if @sugestion_asset.save
      #redirect_to share_sugestion_asset_path(@sugestion_asset), notice: I18n.t('flash.actions.create.sugestion')
      redirect_to sugestion_assets_url
    else
      render :new
    end

  end

  def index
    @sugestions = SugestionAsset.all
    @sugestion_map_coordinates = MapLocation.where(investment_id: @sugestions).map { |l| l.json_data }
    load_map
  end

  def json_data
    sugestion =  SugestionAsset.find(params[:id])
    data = {
      sugestion_id: sugestion.id,
      sugestion_title: sugestion.title,
    }.to_json

    respond_to do |format|
      format.json { render json: data }
    end
  end

  def share
  
  end 

  private

def sugestions_assets_params
  params.require(:sugestion_asset).permit(:title, :description, :skip_map, :latitude, :longitude,
   :visible, :terms_of_service,
   map_location_attributes: [:latitude, :longitude, :zoom]
   )            
end


def load_map
    @map_location = MapLocation.new
    @map_location.zoom = 20
    @map_location.latitude = -22.0090183.to_f
    @map_location.longitude = -47.8914832.to_f
end

end