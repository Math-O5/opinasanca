class SugestionAssetsController < ApplicationController
  include FeatureFlags
  include FlagActions
  
  skip_authorization_check

  before_action :authenticate_user!, except: [:index, :show, :json_data]

  feature_flag :sugestion_assets
  respond_to :html, :js

  has_orders %w{newest oldest}, only: :show # to filter comments

  def show
    if @sugestion_asset.nil?
      @sugestion_asset= SugestionAsset.find_by(id: params[:id])
    end

    @user = User.find_by(id: @sugestion_asset.author_id)

    @commentable = @sugestion_asset
    @comment_tree = CommentTree.new(@commentable, params[:page], @current_order, valuations: true)
  end
  
  def new 
    @sugestion_asset = SugestionAsset.new
  end

  def create
    @sugestion_asset = SugestionAsset.new(sugestions_assets_params.merge(author_id: current_user.id))
    @client = OpenStreetMap::Client.new

    if @sugestion_asset.save
      @map_location = MapLocation.find_by(sugestion_asset_id: @sugestion_asset.id)
      
      @sugestion_asset.latitude = @map_location.latitude
      @sugestion_asset.longitude = @map_location.longitude
      
      data_hash = (@client.reverse(format: 'json', lat: @sugestion_asset.latitude.to_s, lon:  @sugestion_asset.longitude.to_s, accept_language: 'pt-BR'))
      
      puts "#{data_hash}"
      puts "==============================================="
      puts "#{data_hash["display_name"]}"

      @sugestion_asset.display_name = data_hash["display_name"]

      @sugestion_asset.save
      redirect_to(@sugestion_asset)
    else
      render :new
    end
  end

  def index
    @sugestion_assets = SugestionAsset.all
    @sugestion_map_coordinates = MapLocation.where(sugestion_asset_id: @sugestion_assets).map { |l| l.json_data }
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

  # def show
  #  load_comments
  #end
  
  def edit
    @sugestion_asset = SugestionAsset.find(params[:id])

    if @sugestion_asset.update(sugestions_assets_params.merge(author_id: current_user.id))
      redirect_to(@sugestion_asset)
    else
      render s:edit
    end
  end

private

  def load_comments
    @commentable = @sugestion
    @comment_tree = CommentTree.new(@commentable, params[:page], @current_order, valuations: true)
    set_comment_flags(@comment_tree.comments)
  end

def sugestions_assets_params
  params.require(:sugestion_asset).permit(:id, :title, :description, :skip_map, :latitude, :longitude,
   :visible, :terms_of_service, :display_name,
   map_location_attributes: [:latitude, :longitude, :zoom],
   image_attributes: [:id, :title, :attachment, :cached_attachment, :user_id, :_destroy]
   )            
end

def resource_model
  SugestionAsset
end

def resource_name
  'sugestion_asset'
end

def set_sugestion_asset_votes(sugestion_asset)
end

def load_map
    @map_location = MapLocation.new
    @map_location.zoom = 20
    @map_location.latitude = -22.0090183.to_f
    @map_location.longitude = -47.8914832.to_f
end

end