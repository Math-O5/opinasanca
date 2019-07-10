class SugestionAssetsController < ApplicationController
  include FeatureFlags
  include FlagActions
  skip_authorization_check

  before_action :authenticate_user!, except: [:index, :show]

  feature_flag :sugestion_assets
  respond_to :html, :js

  def show  
    load_map 
  end

  def index
    sugestions = SugestionAsset.where(visible: true)

    @sugestion_map_coordinates = MapLocation.where(investment_id: sugestions).map { |l| l.json_data }
    load_map
  end

  def json_data
    investment =  Budget::Investment.find(params[:id])
    data = {
      investment_id: investment.id,
      investment_title: investment.title,
    }.to_json

    respond_to do |format|
      format.json { render json: data }
    end
  end

private

  def load_map
    @map_location = MapLocation.new
    @map_location.zoom = 20
    @map_location.latitude = -22.0090183.to_f
    @map_location.longitude = -47.8914832.to_f
  end

end
