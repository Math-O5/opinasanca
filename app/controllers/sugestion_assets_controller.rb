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
    @sugestions = SugestionAsset.new
  end

  def create
    @sugestions = SugestionAsset.new

    if @sugestions.save
      redirect_to share_proposal_path(@sugestions), notice: I18n.t('flash.actions.create.sugestion')
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

private

def sugestions_params
  params.require(:sugestion_asset).permit(:id, :sugestion_id, :title, :description, :user_id, :skip_map,
                                   map_location_attributes: [:latitude, :longitude, :zoom])
end

def load_map
    @map_location = MapLocation.new
    @map_location.zoom = 20
    @map_location.latitude = -22.0090183.to_f
    @map_location.longitude = -47.8914832.to_f
end

end